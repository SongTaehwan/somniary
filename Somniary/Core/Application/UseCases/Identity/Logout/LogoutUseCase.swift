//
//  LogoutUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct LogoutUseCase {
    typealias Input = Void

    private let repository: RemoteAuthRepository

    init(authRepository: RemoteAuthRepository) {
        self.repository = authRepository
    }

    func execute() async -> VoidResponse {
        await repository.logout()
        TokenRepository.shared.clear()
        return VoidResponse()
    }
}
