//
//  SomniaryHTTPClient.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation
import Alamofire

struct HTTPResponse {
    let url: URL
    let headers: [String:String]
    let status: Int
    let body: Data
}

final class SomniaryHTTPClient<Target: SomniaryEndpoint>: SomniaryNetworking {

    private let session: Session

    init(session: Session = Session.default) {
        self.session = session
    }

    func request(_ endpoint: Target) async -> Result<HTTPResponse, TransportError> {
        #if DEBUG
        print("🌐 [\(endpoint.method.rawValue)] \(endpoint.path) \(String(describing: endpoint.headers))")
        #endif

        let request = session.request(endpoint)
        let dataTask = request.serializingData(automaticallyCancelling: true)
        let responseData = await dataTask.response
        let response = responseData.result

        switch response {
        case.success(let data):
            let status = responseData.response?.statusCode
            let headers = responseData.response?.allHeaderFields as? [String: String]
            let url = responseData.request?.url

            if let status, let headers, let url {
                return .success(HTTPResponse(url: url, headers: headers, status: status, body: data))
            }

            return .failure(Self.mapToTransportError(responseData.error))
        case .failure(let error):
            #if DEBUG
            print("🚨 [\(endpoint.method.rawValue)] \(endpoint.path)")
            #endif
            return .failure(Self.mapToTransportError(error))
        }
    }

    private static func mapToTransportError(_ error: Error?) -> TransportError {
        guard let error else {
            #if DEBUG
            print("🚨 ERROR: unexpected network error occured")
            #endif
            return .unknown
        }

        // Alamofire 에러 매핑
        if let afError = error as? AFError {
            switch afError {
                // Request 오류
            case .invalidURL(_),
                    .parameterEncodingFailed(_),
                    .parameterEncoderFailed(_),
                    .createURLRequestFailed(_),
                    .createUploadableFailed(_),
                    .multipartEncodingFailed(_):
                return .requestBuildFailed

            case .serverTrustEvaluationFailed(_):
                return .tls

            case .explicitlyCancelled:
                return .cancelled

            case .sessionTaskFailed(let underlying as URLError):
                // 위에서 커버 못한 URL 에러는 재귀 처리
                return self.mapToTransportError(underlying)

            default:
                break
            }
        }

        // URLSession/CFNetwork 에러 매핑
        if let urlError = error as? URLError {
            #if DEBUG
            print("🚨 URLError: \(error.localizedDescription)")
            #endif
            let code = urlError.code

            switch code {
            case .notConnectedToInternet: return .network(.offline)
            case .timedOut:               return .network(.timeout)
            case .dnsLookupFailed:        return .network(.dnsLookupFailed)
            case .networkConnectionLost:  return .network(.connectionLost)
            case .httpTooManyRedirects:    return .network(.redirectLoop)
            case .cancelled:              return .cancelled

                // TLS 관련
            case .serverCertificateUntrusted,
                    .serverCertificateHasBadDate,
                    .serverCertificateHasUnknownRoot,
                    .secureConnectionFailed,
                    .clientCertificateRejected,
                    .clientCertificateRequired:
                return .tls

            default:
                #if DEBUG
                print("🚨 Unkown URLError: \(code)")
                #endif
                return .network(.other(code))
            }
        }

        return .unknown
    }
}
