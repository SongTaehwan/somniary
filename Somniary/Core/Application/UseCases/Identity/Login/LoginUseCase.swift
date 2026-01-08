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
            .mapPortFailureToUseCaseError(contract: LoginContractError.self, classifyAsContract: classifyAsContract)

        if case let .success(entity) = result {
            try? TokenRepository.shared.updateToken(entity)
            return result.map { _ in VoidResponse() }
        }

        return result.map { _ in VoidResponse() }
    }

    // TODO: Apple Login
    func execute(_ input: AppleCredential) async -> Result<VoidResponse, LoginUseCaseError> {
        fatalError("Implement Required")
    }

    private func classifyAsContract(_ error: IdentityBoundaryError) -> LoginContractError? {
        switch error {
        case .auth(let error):
            return classifyAuthError(error)
        case .registration(let error):
            return classifyRegistrationError(error)
        }
    }

    private func classifyAuthError(_ error: AuthDomainError) -> LoginContractError? {
        switch error {
        @unknown default:
            return nil
        }
    }

    private func classifyRegistrationError(_ error: RegistrationDomainError) -> LoginContractError? {
        switch error {
        case .alreadyExists(let reason):
            return .none
        }
    }
}
