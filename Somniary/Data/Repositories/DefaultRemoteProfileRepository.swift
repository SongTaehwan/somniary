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
    private let subject: CurrentValueSubject<UserProfile?, Never>
    private let remote: ProfileRemoteDataSource
    // disk cache
    private let local: ProfileLocalDataSource

    // 상태 보호 락
    private let lock = NSLock()
    // in-memory cache
    private var cached: UserProfile?
    private var savedAt: Date?

    // single-flight (동시에 여러 화면이 remoteOnly 호출해도 1번만 요청)
    private var inflight: Task<UserProfile?, Error>?

    // stale 기준 - 3초
    private let ttl: TimeInterval = 3

    // observing
    var currentProfile: AnyPublisher<UserProfile?, Never> {
        subject.eraseToAnyPublisher()
    }

    init(remote: ProfileRemoteDataSource, local: ProfileLocalDataSource) {
        self.remote = remote
        self.local = local

        // 앱 시작 시 로컬에서 즉시 로드
        let diskCache = (try? local.load())
        let domain = diskCache?.dto.toDomain()

        self.cached = domain
        self.savedAt = diskCache?.savedAt
        self.subject = CurrentValueSubject<UserProfile?, Never>(domain)
    }

    // 사용자 프로필 정보 조회
    func getCurrentProfile(policy: FetchPolicy) async throws -> UserProfile? {
        switch policy {
        case .cacheFirst:
            return getCachedOrLocal()
        case .remoteIfStale:
            if let value = getCachedOrLocal(), !isStale() {
                return value
            }

            return try await refreshRemoteSingleFlight()
        case .remoteOnly:
            return try await refreshRemoteSingleFlight()
        }
    }

    func updateProfile(_ command: UpdateProfileCommand) async throws -> UserProfile {
        let dto = try await remote.updateProfile(id: command.id, payload: .init(name: command.name, email: command.email))
        return dto.toDomain()
    }


    // TODO: 도메인 에러 정의
    func setCurrentProfile(_ profile: UserProfile?) async {
        setInMemoryCachedAndPublish(profile, savedAt: profile == nil ? nil : Date())

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
            setInMemoryCachedAndPublish(diskCached, savedAt: Date())
            return diskCached
        }

        return nil
    }

    private func isStale(now: Date = Date()) -> Bool {
        let savedAt = lock.withLock {
            self.savedAt
        }

        guard let savedAt else {
            return true
        }

        return now.timeIntervalSince(savedAt) > ttl
    }

    private func refreshRemoteSingleFlight() async throws -> UserProfile? {
        // 1) 이미 진행 중이면 그 Task를 await
        if let inflight = lock.withLock({ inflight }) {
            return try await inflight.value
        }

        let task = lock.withLock {
            // 2) 없으면 새 Task 생성
            let task = Task<UserProfile?, Error> { [remote, local] in
                do {
                    let dto = try await remote.fetchProfile()
                    let domain = dto.toDomain()
                    try local.save(.init(dto: dto, savedAt: Date()))
                    return domain
                } catch let error as RemoteDataSourceError {
                    throw self.mapToDomainError(error)
                }
            }

            self.inflight = task
            return task
        }

        defer {
            lock.withLock {
                self.inflight = nil
            }
        }

        let fresh = try await task.value
        setInMemoryCachedAndPublish(fresh, savedAt: Date())
        return fresh
    }

    private func setInMemoryCachedAndPublish(_ profile: UserProfile?, savedAt: Date?) {
        lock.withLock {
            self.cached = profile
            self.savedAt = savedAt
        }

        subject.send(profile)
    }

    // TODO: Domain error mapping
    private func mapToDomainError(_ error: Error) -> Error {
        return error
    }
}
