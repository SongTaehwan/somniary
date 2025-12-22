//
//  AppleLoginUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct AppleLoginUseCase: UseCase {
    private let repository: RemoteAuthRepository

    init(repository: RemoteAuthRepository) {
        self.repository = repository
    }

    func execute(_ input: AppleCredential) async throws -> TokenEntity {
        fatalError("Implement Required")
    }
}
