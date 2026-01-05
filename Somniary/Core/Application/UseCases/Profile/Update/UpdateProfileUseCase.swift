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
        let result = await repository.updateProfile(.init(id: input.id, name: input.name, email: input.email)).mapError { portFailure -> UpdateProfileUseCaseError in
            switch portFailure {
            case .system(let systemError):
                return .system(systemError)
            case .boundary(let boundaryError):
                return mapToUseCaseError(boundaryError)
            }
        }

        return result
    }

    private func mapToUseCaseError(_ boundaryError: ProfileBoundaryError) -> UpdateProfileUseCaseError {
        return .from(boundaryError: boundaryError) { error in
            switch error {
            case .profile(let domainError):
                return classifyProfileError(domainError)
            case .auth(let domainError):
                return classifyAuthError(domainError)
            }
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
