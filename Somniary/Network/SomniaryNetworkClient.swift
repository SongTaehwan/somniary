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
        print("🌐 [\(endpoint.method.rawValue)] \(endpoint.path)")
        #endif

        do {
            let result = try await self.session.request(endpoint)
                .serializingDecodable(T.self, decoder: decoder)
                .value
            #if DEBUG
            print("✅ Response: \(result)")
            #endif
            return result
        } catch let AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode)) {
            throw NetworkError.from(statusCode: statusCode)

        } catch let AFError.responseSerializationFailed(reason: .decodingFailed(error: decodingError)) {
            throw NetworkError.decodingError(decodingError)

        } catch let AFError.sessionTaskFailed(error: urlError) {
            if let urlError = urlError as? URLError {
                // 네트워크 연결 실패 (타임아웃, 인터넷 연결 없음 등)
                throw NetworkError.networkError(urlError)
            }

            throw NetworkError.unknown

        } catch AFError.invalidURL {
            throw NetworkError.invalidRequest

        } catch {
            throw NetworkError.unknown
        }
    }
}
