//
//  SomniaryEndpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation
import Alamofire

protocol SomniaryEndpoint: Endpoint {}

/// 도메인 공통 로직 추가
extension SomniaryEndpoint {
    /// DIP 트레이드 오프
    var baseURL: URL {
        guard let url = URL(string: AppInfo.shared.domainServiceURL) else {
            fatalError("AppInfo.shared.domainServiceURL is nil")
        }

        return url
    }

    /// DIP 트레이드 오프
    var headers: HTTPHeaders? {
        return HTTPHeaders([
            "apiKey": AppInfo.shared.domainClientKey
        ])
    }
}
