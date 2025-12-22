//
//  ObserveCurrentProfileUseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation
import Combine

struct ObserveCurrentProfileUseCase {
    private let repository: RemoteProfileRepository

    init(repository: RemoteProfileRepository) {
        self.repository = repository
    }

    // TODO: Domain error
    func execute() -> AnyPublisher<UserProfile?, Never> {
        // TODO: 로그인 상태 + 프로필 결합한 규칙 추가, Throttle 정책
        // TODO: Refresh Trigger 오케스트레이션(행위)
        return repository.currentProfile
    }
}
