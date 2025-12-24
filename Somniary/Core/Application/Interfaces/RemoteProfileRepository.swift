//
//  RemoteProfileRepository.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation
import Combine

struct UpdateProfileCommand: Equatable {
    let id: String
    let name: String?
    let email: String?
}

protocol RemoteProfileRepository {
    // 여러 ViewModel 에서 구독할 공유 스트림
    var currentProfile: AnyPublisher<UserProfile?, Never> { get }

    // 1회성 조회
    func getCurrentProfile(policy: FetchPolicy) async throws -> UserProfile?

    // TODO: Request Model
    // API 를 통한 변경
    func updateProfile(_ command: UpdateProfileCommand) async throws -> UserProfile

    // TODO: 제거할지?
    // 로컬에 업데이트 결과 즉시 반영
    func setCurrentProfile(_ profile: UserProfile?) async
}
