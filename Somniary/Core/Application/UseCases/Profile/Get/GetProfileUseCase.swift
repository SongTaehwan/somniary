//
//  GetProfileUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct GetProfileUseCase: UseCase {
    private let repository: RemoteProfileRepository

    init(repository: RemoteProfileRepository) {
        self.repository = repository
    }

    func execute(_ policy: FetchPolicy = .remoteIfStale) async -> Result<UserProfile, GetProfileUseCaseError> {
        let profileResult = await repository.getCurrentProfile(policy: policy)
            .mapError { portFailure -> GetProfileUseCaseError in
                switch portFailure {
                case .application(let appError):
                    return .application(appError)
                case .domain(let failureCause):
                    return mapToUseCaseError(failureCause)
                }
            }

        return profileResult
    }

    private func mapToUseCaseError(_ failureCause: ProfileFailureCause) -> GetProfileUseCaseError {
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
        case .loginRequired:
            return .contract(.precondition(.loginRequired))
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
