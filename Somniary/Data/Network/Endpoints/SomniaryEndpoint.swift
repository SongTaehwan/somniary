//
//  SomniaryEndpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

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
        return [
            "apiKey": AppInfo.shared.domainClientKey,
            "Content-Type": "application/json"
        ]
    }

    func asURLRequest() throws -> URLRequest {
        let url = self.baseURL.appending(path: self.path, queryItems: self.queryItems ?? [])
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.httpBody = try encodePayload()

        return request
    }

    private func encodePayload() throws -> Data? {
        if case let .jsonObject(data) = self.payload {
            let data = try JSONSerialization.data(withJSONObject: data)
            return data
        }

        if case let .entity(data) = self.payload {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(data)
            return data
        }

        return nil
    }
}
