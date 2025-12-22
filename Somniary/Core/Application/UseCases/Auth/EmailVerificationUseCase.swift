//
//  AuthVerificationUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct EmailVerificationUseCase: UseCase {
    struct Input {
        // TODO: validate request model
        let email: String
    }

    private let repository: RemoteAuthRepository

    init(repository: RemoteAuthRepository) {
        self.repository = repository
    }

    func execute(_ input: Input) async throws -> VoidResponse {
        return try await repository.requestOtpCode(email: input.email, createUser: true, idempotencyKey: nil)
    }
}
