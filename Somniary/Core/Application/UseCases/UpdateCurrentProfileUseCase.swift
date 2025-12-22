//
//  UpdateProfileUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct UpdateCurrentProfileUseCase {
    struct Input {
        let id: String
        let name: String?
        let email: String?
    }

    private let repository: RemoteProfileRepository

    init(repository: RemoteProfileRepository) {
        self.repository = repository
    }

    func execute(_ input: Input) async throws -> UserProfile {
        try await repository.updateProfile(.init(id: input.id, name: input.name, email: input.email))
    }
}
