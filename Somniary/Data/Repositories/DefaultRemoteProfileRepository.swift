//
//  DefaultRemoteProfileRepository.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation
import Combine

// TODO: In-memory 캐시 위치 고민해볼 것
// TODO: Domain error mapping
final class DefaultRemoteProfileRepository: RemoteProfileRepository {
    private let remote: ProfileRemoteDataSource
    // disk cache
    private let local: ProfileLocalDataSource

    // 상태 보호 락
    private let lock = NSLock()
    // in-memory cache
    private var cached: UserProfile?
    private var savedAt: Date?

    // single-flight (동시에 여러 화면이 remoteOnly 호출해도 1번만 요청)
    private var inflight: Task<Result<UserProfile, PortFailure<ProfileBoundaryError>>, Error>?

    // stale 기준 - 3초
    private let ttl: TimeInterval = 3

    private var isStale: Bool {
        guard let savedAt = lock.withLock({ self.savedAt }) else {
            return true
        }

        return Date.now.timeIntervalSince(savedAt) > ttl
    }

    init(remote: ProfileRemoteDataSource, local: ProfileLocalDataSource) {
        self.remote = remote
        self.local = local

        // 앱 시작 시 로컬에서 즉시 로드
        let diskCache = (try? local.load())
        let domain = diskCache?.dto.toDomain()

        self.cached = domain
        self.savedAt = diskCache?.savedAt
    }

    // 사용자 프로필 정보 조회
    func getProfile(policy: FetchPolicy) async -> Result<UserProfile, PortFailure<ProfileBoundaryError>> {
        switch policy {
        case .cacheFirst:
            if let cache = getCachedOrLocal() {
                return .success(cache)
            }

            return await refreshRemoteSingleFlight()
        case .remoteIfStale:
            if isStale == false, let value = getCachedOrLocal() {
                return .success(value)
            }

            return await refreshRemoteSingleFlight()
        case .remoteOnly:
            return await refreshRemoteSingleFlight()
        }
    }

    // TODO: write 작업 시에는 어떻게 처리할지? cancel?
    func updateProfile(_ command: UpdateProfileCommand) async -> Result<UserProfile, PortFailure<ProfileBoundaryError>> {
        let result = await remote.updateProfile(id: command.id, payload: .init(name: command.name, email: command.email))
            .mapError(mapToDomainError(_:))
            .map { dto in
                dto.toDomain()
            }

        return result
    }

    func setProfile(_ profile: UserProfile?) async {
        setInMemoryCached(profile, savedAt: profile == nil ? nil : Date())

        do {
            if let profile {
                try local.save(.init(dto: profile.toDto(), savedAt: Date()))
            } else {
                try local.delete()
            }
        } catch {
            // 로컬 저장 실패를 어떻게 다룰지는 팀 정책(무시/리포트/재시도)
        }
    }

    private func getCachedOrLocal() -> UserProfile? {
        let memoryCached = lock.withLock {
            self.cached
        }

        if let memoryCached {
            return memoryCached
        }

        if let diskCached = try? local.load()?.dto.toDomain() {
            setInMemoryCached(diskCached, savedAt: Date())
            return diskCached
        }

        return nil
    }

    private func ensureSingleFlight(create: @escaping () -> Task<Result<UserProfile, PortFailure<ProfileBoundaryError>>, Error>) -> Task<Result<UserProfile, PortFailure<ProfileBoundaryError>>, Error> {
        // 1) 이미 진행 중이면 해당 Task를 await
        if let existing = lock.withLock({ inflight }) {
            return existing
        }

        // 2) 새 Task는 락 밖에서 생성 (락 점유 시간 최소화)
        let newTask = create()

        // 3) 다시 락을 잡고 재확인 후 publish 또는 기존 반환
        return lock.withLock {
            if let existing = inflight {
                // 누군가 먼저 설정했다면, 우리가 만든 건 버리고 기존 것을 사용
                return existing
            }

            inflight = newTask
            return newTask
        }
    }

    private func refreshRemoteSingleFlight() async -> Result<UserProfile, PortFailure<ProfileBoundaryError>> {
        let task = ensureSingleFlight {
            Task { [weak self] in
                guard let self else {
                    throw CancellationError()
                }

                let dtoResult = await remote.fetchProfile()
                    .mapError(mapToDomainError(_:))

                if case let .success(dto) = dtoResult {
                    persistAndCache(dto: dto)
                }

                return dtoResult.map { $0.toDomain() }
            }
        }

        defer {
            lock.withLock {
                if self.inflight == task {
                    self.inflight = nil
                }
            }
        }

        return await handleTask(task)
    }

    private func setInMemoryCached(_ profile: UserProfile?, savedAt: Date?) {
        lock.withLock {
            self.cached = profile
            self.savedAt = savedAt
        }
    }

    private func handleTask<T>(_ task: Task<Result<T, PortFailure<ProfileBoundaryError>>, any Error>) async -> Result<T, PortFailure<ProfileBoundaryError>> {
        let taskResult = await Result<T, PortFailure<ProfileBoundaryError>>.catching {
            try await task.value.get()
        } mapError: { error in
            if let _ = error as? CancellationError {
                return .system(.dependencyUnavailable(details: "cancelled"))
            }

            if let boundaryError = error as? PortFailure<ProfileBoundaryError> {
                return boundaryError
            }

            return .system(.dependencyUnavailable(details: "Task.value failed: \(error.localizedDescription)"))
        }

        #if DEBUG
        if case .failure(let portFailure) = taskResult {
            portFailure.debugPrint()
        }
        #endif

        return taskResult
    }

    private func persistAndCache(dto: NetProfile.Get.Response) {
        try? local.save(.init(dto: dto, savedAt: Date()))
        setInMemoryCached(dto.toDomain(), savedAt: Date())
    }

    private func mapToDomainError(_ error: Error) -> PortFailure<ProfileBoundaryError> {
        guard let datasourceError = error as? DataSourceError else {
            return .system(.internalInvariantViolation(reason: "Unhandled error: \(error)"))
        }

        switch datasourceError {
        case .transport(let transportError):
            switch transportError {
            case .cancelled:
                return .system(.dependencyUnavailable(details: "cancelled"))
            case .network(_), .tls, .unknown:
                return .system(.dependencyUnavailable(details: "network error"))
            case .requestBuildFailed:
                return .system(.contractViolation(details: "Failed to build URL request"))
            }
        case .unauthorized(let unauthorizedReason):
            switch unauthorizedReason {
            case .tokenExpired:
                return .boundary(.auth(.authRequired(reason: .accessTokenExpired)))
            case .invalidToken:
                return .boundary(.auth(.authRequired(reason: .accessTokenInvalid)))
            case .unauthorized:
                return .boundary(.auth(.authRequired(reason: .unknownUnauthorized)))
            }
        case .forbidden(let forbiddenReason):
            switch forbiddenReason {
            case .roleDenied:
                return .boundary(.auth(.permissionDenied(reason: .roleDenied)))
            case .insufficientScope:
                return .boundary(.auth(.permissionDenied(reason: .insufficientScope)))
            case .resourceForbidden:
                return .boundary(.auth(.permissionDenied(reason: .resourceForbidden)))
            case .forbidden:
                return .boundary(.auth(.permissionDenied(reason: .unknownForbidden)))
            }
        case .resource(let resourceReason):
            switch resourceReason {
            case .notSingular:
                return .system(.contractViolation(details: "Not Singlular"))
            case .conflict:
                return .system(.contractViolation(details: "Conflict"))
            case .notFound:
                // 응답을 기대하는데 없는 경우에 해당
                return .system(.contractViolation(details: "Not Found"))
            }
        case .client(let clientReason):
            // 요청에 대한 계약 위반으로 간주
            return .system(.contractViolation(details: "HTTP 4xx: \(clientReason)"))
        case .server(let serverReason):
            // 의존성 실패로 간주
            return .system(.dependencyUnavailable(details: "internal server error: \(serverReason)"))
        case .response(let responseReason):
            // 응답에 대한 계약 위반으로 간주
            switch responseReason {
            case .emptyResponse:
                return .system(.contractViolation(details: "Empty Response"))
            case .invalidPayload:
                return .system(.contractViolation(details: "Invalid Payload"))
            case .decodingFailed:
                return .system(.contractViolation(details: "decodingFailed"))
            }
        case .invariantViolation(let reason):
            return .system(.internalInvariantViolation(reason: reason))
        }
    }
}
