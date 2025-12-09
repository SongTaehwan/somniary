//
//  HTTPClient.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation
import Alamofire

final class HTTPClient<Target: Endpoint>: HTTPNetworking {
    private let session: Session

    init(session: Session = Session.default) {
        self.session = session
    }

    func request(_ endpoint: Target) async -> Result<HTTPResponse, TransportError> {
        #if DEBUG
        print("🌐 [\(endpoint.method.rawValue)] \(endpoint.path) \(String(describing: endpoint.headers))")
        #endif

        guard let request = try? endpoint.asURLRequest() else {
            return .failure(TransportError.requestBuildFailed)
        }

        let dataRequest = session.request(request)
        let dataResponse = await dataRequest.serializingData().response

        //  에러 핸들링
        if let error = dataResponse.error {
            #if DEBUG
            print("🚨 [\(endpoint.method.rawValue)] \(endpoint.path)")
            #endif
            return .failure(Self.mapToTransportError(error))
        }

        let response = dataResponse.result

        // 응답 처리
        guard let httpResponse = dataResponse.response, let url = dataResponse.request?.url else {
//            DebugAssert.fail(category: .network, "네트워크 통신은 성공했지만 URL 정보나 HTTPResponse 정보가 없습니다.")
            return .failure(TransportError.unknown)
        }

        let headers = httpResponse.allHeaderFields as? [String: String] ?? [:]
        let status = httpResponse.statusCode
        let body = dataResponse.data

        return .success(HTTPResponse(url: url, headers: headers, status: status, body: body))
    }

    private static func mapToTransportError(_ error: Error?) -> TransportError {
        guard let error else {
            #if DEBUG
            print("🚨 ERROR: unexpected network error occured")
            #endif
//            DebugAssert.fail(category: .network, "네트워크 에러 정보가 없습니다.")
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
