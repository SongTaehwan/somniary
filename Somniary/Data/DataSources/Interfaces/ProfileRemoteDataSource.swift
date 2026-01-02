//
//  RemoteProfileDataSource.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

protocol ProfileRemoteDataSource {
    func fetchProfile() async -> Result<NetProfile.Get.Response, DataSourceError>
    func updateProfile(id: String, payload: NetProfile.Update.Request) async -> Result<NetProfile.Get.Response, DataSourceError>
}
