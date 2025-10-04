//
//  SomniaryNetwork.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation
import Alamofire

final class SomniaryNetworkClient<Target: SomniaryEndpoint>: SomniaryNetworking {

    private let decoder: JSONDecoder
    private let session: Session

    init(decoder: JSONDecoder = JSONDecoder(), session: Session = Session.default) {
        self.decoder = decoder
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Target, type: T.Type) async throws -> T {
        #if DEBUG
        print("🌐 [\(endpoint.method.rawValue)] \(endpoint.path) \(String(describing: endpoint.headers))")
        #endif

        let response = await self.session.request(endpoint)
            .validate(statusCode: 200..<300)
            .serializingDecodable(T.self, decoder: decoder)
            .result

        switch response {
        case.success(let result):
            #if DEBUG
            print("✅ Response: \(result)")
            #endif
            return result
        case .failure(let error):
            #if DEBUG
            print("🚨 [\(endpoint.method.rawValue)] \(endpoint.path)")
            #endif
            throw mapError(error)
        }
    }

    private func mapError(_ error: AFError) -> NetworkError {
        print("🚨 ERROR - \(error.localizedDescription)")

        switch error {
        case .responseValidationFailed(reason: .unacceptableStatusCode(code: let statusCode)):
            return NetworkError.from(statusCode: statusCode)
        case let .responseSerializationFailed(reason: .decodingFailed(error: decodingError)):
            return NetworkError.decodingError(decodingError)
        case let .sessionTaskFailed(error: urlError):
            if let urlError = urlError as? URLError {
                // 네트워크 연결 실패 (타임아웃, 인터넷 연결 없음 등)
                return NetworkError.networkError(urlError)
            }

            return NetworkError.unknown
        case .invalidURL:
            return NetworkError.invalidRequest
        default:
            return NetworkError.unknown
        }
    }
}
