//
//  NetworkProvider.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

final class NetworkClientProvider {
    static func getNetworkClient<Target: SomniaryEndpoint>() -> HTTPClient<Target> {
        return HTTPClient()
    }
}

extension NetworkClientProvider {
    static let userNetworkClient = HTTPClient<UserEndpoint>()
    static let diaryNetworkClient = HTTPClient<DiaryEndpoint>()
    static let authNetworkClient = HTTPClient<AuthEndpoint>()
}
