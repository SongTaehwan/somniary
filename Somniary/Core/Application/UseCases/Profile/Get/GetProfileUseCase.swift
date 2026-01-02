//
//  GetProfileUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct GetProfileUseCase {
    private let repository: RemoteProfileRepository

    init(repository: RemoteProfileRepository) {
        self.repository = repository
    }

    func execute(_ policy: FetchPolicy = .remoteIfStale) async -> Result<UserProfile, GetProfileUseCaseError> {
        let profileResult = await repository.getProfile(policy: policy)
            .mapError { portFailure -> GetProfileUseCaseError in
                switch portFailure {
                case .system(let systemError):
                    return .system(systemError)
                case .domain(let failureCause):
                    return mapToUseCaseError(failureCause)
                }
            }

        return profileResult
    }

    private func mapToUseCaseError(_ failureCause: ProfileBoundaryError) -> GetProfileUseCaseError {
        return .from(failureCause: failureCause) { cause in
            switch cause {
            case .auth(let error):
                return classifyAuthError(error)
            case .profile(let error):
                return classifyProfileError(error)
            }
        }
    }

    private func classifyAuthError(_ error: AuthDomainError) -> GetProfileUseCaseError.Classification {
        switch error {
        default:
            return .outOfContract
        }
    }

    private func classifyProfileError(_ error: ProfileDomainError) -> GetProfileUseCaseError.Classification {
        switch error {
        case .invalidNickname(reason: let reason):
            return .contract(.invalidNickname)
        }
    }
}
