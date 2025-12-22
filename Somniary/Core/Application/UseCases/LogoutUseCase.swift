//
//  LogoutUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct LogoutUseCase: UseCase {
    typealias Input = Void

    private let authRepository: RemoteAuthRepository

    init(authRepository: RemoteAuthRepository) {
        self.authRepository = authRepository
    }

    func execute() async throws -> VoidResponse {
        try await self.authRepository.logout()
        TokenRepository.shared.clear()
        return VoidResponse()
    }
}
