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
            .mapPortFailureToUseCaseError(contract: RequestOtpContractError.self, classifyAsContract: classifyAsContract(_:))
            .map { VoidResponse() }

        return result
    }

    private func classifyAsContract(_ error: IdentityBoundaryError) -> RequestOtpContractError? {
        switch error {
        case .auth(let error):
            return classifyAuthError(error)
        case .registration(let error):
            return classifyRegistrationError(error)
        }
    }

    private func classifyRegistrationError(_ error: RegistrationDomainError) -> RequestOtpContractError? {
        switch error {
        case .alreadyExists(let reason):
            return .alreadyRegistered
        }
    }

    private func classifyAuthError(_ error: AuthDomainError) -> RequestOtpContractError? {
        switch error {
        @unknown default:
            return nil
        }
    }
}
