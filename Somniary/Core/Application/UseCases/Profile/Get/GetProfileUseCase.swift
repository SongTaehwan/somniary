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
                case .system(let error):
                    return .system(error)
                case .boundary(let error):
                    return mapToUseCaseError(error)
                }
            }

        return profileResult
    }

    // TODO: 매핑 로직 프로토콜 레벨에서 공통화

    private func mapToUseCaseError(_ error: ProfileBoundaryError) -> GetProfileUseCaseError {
        return .from(boundaryError: error) { boundaryError in
            switch boundaryError {
            case .auth(let error):
                return classifyAuthError(error)
            case .profile(let error):
                return classifyProfileError(error)
            }
        }
    }

    private func classifyAuthError(_ error: AuthDomainError) -> GetProfileContractError? {
        switch error {
        default:
            return nil
        }
    }

    private func classifyProfileError(_ error: ProfileDomainError) -> GetProfileContractError {
        switch error {
        case .invalidNickname(reason: let reason):
            return .invalidNickname
        }
    }
}
