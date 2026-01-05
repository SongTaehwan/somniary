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
        let result = await repository.getProfile(policy: policy)
            .mapPortFailureToUseCaseError(contract: GetProfileContractError.self, classifyAsContract: classifyAsContract(_:))

        return result
    }

    private func classifyAsContract(_ error: ProfileBoundaryError) -> GetProfileContractError? {
        switch error {
        case .auth(let error):
            return classifyAuthError(error)
        case .profile(let error):
            return classifyProfileError(error)
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
