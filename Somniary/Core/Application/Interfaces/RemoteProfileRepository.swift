//
//  RemoteProfileRepository.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct UpdateProfileCommand: Equatable {
    let id: String
    let name: String?
    let email: String?
}

protocol RemoteProfileRepository {
    // 1회성 조회
    func getProfile(policy: FetchPolicy) async -> Result<UserProfile, PortFailure<ProfileFailureCause>>

    // API 를 통한 변경
    func updateProfile(_ command: UpdateProfileCommand) async -> Result<UserProfile, PortFailure<ProfileFailureCause>>

    // TODO: 제거할지?
    // 로컬에 업데이트 결과 즉시 반영
    func setProfile(_ profile: UserProfile?) async
}
