//
//  LoginUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct LoginUseCase {
    struct Input {
        // TODO: validate request model
        let email: String
        let otpCode: String
    }

    private let repository: RemoteAuthRepository

    init(repository: RemoteAuthRepository) {
        self.repository = repository
    }

    func execute(_ input: Input) async -> Result<VoidResponse, LoginUseCaseError> {
        let result = await repository.verify(email: input.email, otpCode: input.otpCode, idempotencyKey: nil)
            .mapError { portFailure -> LoginUseCaseError in
                switch portFailure {
                case .domain(let failureCause):
                    return mapToUseCaseError(failureCause)
                case .system(let systemError):
                    return .system(systemError)
                }
            }

        if case let .success(entity) = result {
            try? TokenRepository.shared.updateToken(entity)
            return result.map { _ in VoidResponse() }
        }

        return result.map { _ in VoidResponse() }
    }

    func execute(_ input: AppleCredential) async -> Result<VoidResponse, LoginUseCaseError> {
        fatalError("Implement Required")
    }

    private func mapToUseCaseError(_ failureCause: IdentityBoundaryError) -> LoginUseCaseError {
        return .from(failureCause: failureCause) { error in
            switch error {
            case .auth(let domainError):
                return classifyFailureCause(domainError)
            @unknown default:
                return .outOfContract
            }
        }
    }

    private func classifyFailureCause(_ error: AuthDomainError) -> LoginUseCaseError.Classification {
        switch error {
        @unknown default:
            return .outOfContract
        }
    }
}
