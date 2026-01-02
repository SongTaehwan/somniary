//
//  DefaultRemoteProfileDataSource.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct DefaultProfileRemoteDataSource: ProfileRemoteDataSource, DataSourceSupport {
    private let client: HTTPClient<UserEndpoint>

    init(client: HTTPClient<UserEndpoint>) {
        self.client = client
    }

    func fetchProfile() async -> Result<NetProfile.Get.Response, DataSourceError> {
        let httpResult = await client.request(.getProfile)
        return handleTransportResult(httpResult)
    }

    func updateProfile(id: String, payload: NetProfile.Update.Request) async -> Result<NetProfile.Get.Response, DataSourceError> {
        let httpResult = await client.request(.update(id: id, payload: payload))
        return handleTransportResult(httpResult)
    }
}
