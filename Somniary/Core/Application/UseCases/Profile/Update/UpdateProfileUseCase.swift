//
//  UpdateProfileUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct UpdateProfileUseCase {
    struct Input {
        let id: String
        let name: String?
        let email: String?
    }

    private let repository: RemoteProfileRepository

    init(repository: RemoteProfileRepository) {
        self.repository = repository
    }

    func execute(_ input: Input) async -> Result<UserProfile, UpdateProfileUseCaseError> {
        let result = await repository.updateProfile(.init(id: input.id, name: input.name, email: input.email))
            .mapPortFailureToUseCaseError(contract: UpdateProfileConractError.self, classifyAsContract: classifyAsContract(_:))

        return result
    }

    private func classifyAsContract(_ error: ProfileBoundaryError) -> UpdateProfileConractError? {
        switch error {
        case .profile(let error):
            return classifyProfileError(error)
        case .auth(let error):
            return classifyAuthError(error)
        }
    }

    private func classifyAuthError(_ error: AuthDomainError) -> UpdateProfileConractError? {
        switch error {
        default:
            return .none
        }
    }

    private func classifyProfileError(_ error: ProfileDomainError) -> UpdateProfileConractError? {
        switch error {
        case .invalidNickname(let reason):
            return .none
        }
    }
}
