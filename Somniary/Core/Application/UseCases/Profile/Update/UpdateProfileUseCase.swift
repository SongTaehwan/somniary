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
        let result = await repository.updateProfile(.init(id: input.id, name: input.name, email: input.email)).mapError { failureCause -> UpdateProfileUseCaseError in
            switch failureCause {
            case .application(let appError):
                return .application(appError)
            case .domain(let cause):
                return mapToUseCaseError(cause)
            }
        }

        return result
    }

    private func mapToUseCaseError(_ failureCause: ProfileFailureCause) -> UpdateProfileUseCaseError {
        return .from(failureCause: failureCause) { cause in
            switch cause {
            case .profile(let domainError):
                return classifyProfileError(domainError)
            case .auth(let domainError):
                return classifyAuthError(domainError)
            }
        }
    }

    private func classifyAuthError(_ error: AuthDomainError) -> UpdateProfileUseCaseError.Classification {
        switch error {
        default:
            return .outOfContract
        }
    }

    private func classifyProfileError(_ error: ProfileDomainError) -> UpdateProfileUseCaseError.Classification {
        switch error {
        case .invalidNickname(let reason):
            return .outOfContract
        }
    }
}
