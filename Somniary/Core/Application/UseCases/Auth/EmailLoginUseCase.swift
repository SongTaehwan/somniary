//
//  EmailLoginUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct EmailLoginUseCase: UseCase {
    struct Input {
        // TODO: validate request model
        let email: String
        let otpCode: String
    }

    private let authRepository: RemoteAuthRepository

    init(authRepository: RemoteAuthRepository) {
        self.authRepository = authRepository
    }

    func execute(_ input: Input) async throws -> TokenEntity {
        let entity = try await authRepository.verify(email: input.email, otpCode: input.otpCode, idempotencyKey: nil)

        try TokenRepository.shared.updateToken(entity)
        
        return entity
    }
}
