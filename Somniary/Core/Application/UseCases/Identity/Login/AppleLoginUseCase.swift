//
//  AppleLoginUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct AppleLoginUseCase {
    private let repository: RemoteAuthRepository

    init(repository: RemoteAuthRepository) {
        self.repository = repository
    }

    func execute(_ input: AppleCredential) async -> Result<VoidResponse, EmailLoginUseCaseError> {
        fatalError("Implement Required")
    }
}
