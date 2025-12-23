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

    func fetchProfile() async throws -> NetProfile.Get.Response {
        let httpResult = await client.request(.getProfile)
            .mapError(self.mapTransportError(_:))
        return try decodeHttpResult(httpResult)
    }

    func updateProfile(id: String, payload: NetProfile.Update.Request) async throws -> NetProfile.Get.Response {
        let httpResult = await client.request(.update(id: id, payload: payload))
            .mapError(self.mapTransportError(_:))
        return try decodeHttpResult(httpResult)
    }
}
