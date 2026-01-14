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

    func execute() async -> Result<VoidResponse, LogoutUseCaseError> {
        let result = await repository.logout()
            .mapPortFailureToUseCaseError(contract: LogoutContractError.self) { error in
                return .none
            }
            .map { _ in VoidResponse() }

        #if DEBUG
        if case .failure(let failure) = result {
            failure.debugPrint()
        }
        #endif

        TokenRepository.shared.clear()

        return result
    }
}
