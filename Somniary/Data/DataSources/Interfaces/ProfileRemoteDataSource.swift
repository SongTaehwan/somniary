//
//  RemoteProfileDataSource.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

protocol ProfileRemoteDataSource {
    func fetchProfile() async throws -> NetProfile.Get.Response
    func updateProfile(id: String, payload: NetProfile.Update.Request) async throws -> NetProfile.Get.Response
}
