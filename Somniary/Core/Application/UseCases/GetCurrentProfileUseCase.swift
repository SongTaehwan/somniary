//
//  GetProfileUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct GetCurrentProfileUseCase: UseCase {
    private let repository: RemoteProfileRepository

    init(repository: RemoteProfileRepository) {
        self.repository = repository
    }

    func execute(_ policy: FetchPolicy = .remoteIfStale) async throws -> UserProfile? {
        return try await repository.getCurrentProfile(policy: policy)
    }
}
