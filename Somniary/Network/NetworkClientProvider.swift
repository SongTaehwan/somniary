//
//  NetworkProvider.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

final class NetworkClientProvider {
    
    static func getNetworkClient<Target: SomniaryEndpoint>() -> SomniaryHTTPClient<Target> {
        return SomniaryHTTPClient()
    }
}

extension NetworkClientProvider {

    static let userNetworkClient = SomniaryHTTPClient<UserEndpoint>()
    static let diaryNetworkClient = SomniaryHTTPClient<DiaryEndpoint>()
    static let authNetworkClient = SomniaryHTTPClient<AuthEndpoint>()
}
