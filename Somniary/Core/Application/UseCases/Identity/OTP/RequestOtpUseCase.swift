//
//  RequestOtpUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct RequestOtpUseCase {
    struct Input {
        // TODO: validate request model
        let email: String
    }

    private let repository: RemoteAuthRepository

    init(repository: RemoteAuthRepository) {
        self.repository = repository
    }

    func execute(_ input: Input) async -> Result<VoidResponse, RequestOtpUseCaseError> {
        let result = await repository.requestOtpCode(email: input.email, createUser: true, idempotencyKey: nil)
            .mapError { portFailure -> RequestOtpUseCaseError in
                switch portFailure {
                case .domain(let failureCause):
                    return mapToUseCaseError(failureCause)
                case .system(let systemError):
                    return .system(systemError)
                }
            }
            .map { VoidResponse() }

        return result
    }

    private func mapToUseCaseError(_ failureCause: IdentityBoundaryError) -> RequestOtpUseCaseError {
        return .from(failureCause: failureCause) { domainError in
            switch domainError {
            case .auth(let error):
                return classifyAuthError(error)
            case .registration(let error):
                return classifyRegistrationError(error)
            }
        }
    }

    private func classifyRegistrationError(_ error: RegistrationDomainError) -> RequestOtpUseCaseError.Classification {
        switch error {
        case .alreadyExists(let reason):
            return .contract(.alreadyRegistered)
        }
    }

    private func classifyAuthError(_ error: AuthDomainError) -> RequestOtpUseCaseError.Classification {
        switch error {
        case .accountRestricted(reason: let reason):
            return .outOfContract
        case .permissionDenied(reason: let reason):
            return .outOfContract
        case .authRequired(reason: let reason):
            return .outOfContract
        }
    }
}
