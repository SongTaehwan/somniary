//
//  SomniaryNetwork.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation
import Alamofire

final class SomniaryNetworkClient<Target: SomniaryEndpoint>: SomniaryNetworking {

    private let decoder = JSONDecoder()
    private let session = {
        let configuration = URLSessionConfiguration.af.default
        let session = Session(configuration: configuration)
        return session
    }()


    func request<T: Decodable>(_ endpoint: Target, type: T.Type) async throws -> T {
        let result = try await self.session.request(endpoint).serializingDecodable(T.self, decoder: decoder).value
        return result
    }
}
