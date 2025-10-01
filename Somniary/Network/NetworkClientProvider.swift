//
//  NetworkProvider.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

final class NetworkClientProvider {
    
    static func getNetworkClient<Target: SomniaryEndpoint>() -> SomniaryNetworkClient<Target> {
        return SomniaryNetworkClient()
    }
}

extension NetworkClientProvider {

    static let userNetworkClient = SomniaryNetworkClient<UserEndpoint>()
    static let diaryNetworkClient = SomniaryNetworkClient<DiaryEndpoint>()
    static let authNetworkClient = SomniaryNetworkClient<AuthEndpoint>()
}
