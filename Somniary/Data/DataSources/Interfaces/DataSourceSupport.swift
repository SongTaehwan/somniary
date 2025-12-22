//
//  DataSourceSupport.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

/// [check] 호출하는 서버 규약에 따라 개별적인 매핑 로직이 필요
protocol DataSourceSupport {
    func decodeResponse<T: Decodable>(_ httpResponse: HTTPResponse) throws -> T
    func mapHTTPStatusToError(_ statusCode: Int) -> RemoteDataSourceError
    func mapTransportError(_ error: TransportError) -> RemoteDataSourceError
}

extension DataSourceSupport {
    /// 응답 데이터를 DTO 로 변환
    func decodeResponse<T: Decodable>(_ httpResponse: HTTPResponse) throws -> T {
        let statusCode = httpResponse.status

        // http 프로토콜 에러 처리
        guard (200...299).contains(statusCode) else {
            throw self.mapHTTPStatusToError(statusCode)
        }

        guard let data = httpResponse.body, data.isEmpty == false else {
            throw RemoteDataSourceError.emptyResponse
        }

        // JSON 디코딩
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            #if DEBUG
            print("🚨 Decoding failed: \(error)")
            if let json = String(data: data, encoding: .utf8) {
                print("📄 Response body: \(json)")
            }
            #endif
            throw RemoteDataSourceError.decodingFailed
        }
    }

    /// 책임: 네트워크 프로토콜 해석
    func mapHTTPStatusToError(_ statusCode: Int) -> RemoteDataSourceError {
        switch statusCode {
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 409:
            return .conflict
        case 400, 422, 400...499:
            return .invalidRequest
        case 500...599:
            return .serverError
        default:
            DebugAssert.fail(category: .network, "Unhandled status code: \(statusCode)")
            return .unknown
        }
    }

    /// 책임: 네트워크 전송 에러 해석
    func mapTransportError(_ error: TransportError) -> RemoteDataSourceError {
        switch error {
        case .network(.offline):
            return .networkUnavailable
        case .network(.timeout):
            return .timeout
        case .network(.connectionLost), .network(.dnsLookupFailed):
            return .networkUnavailable
        case .network(.redirectLoop):
            // 서버 에러로 간주
            return .serverError
        case .network(.other(_)):
            return .networkUnavailable
        case .cancelled:
            return .cancelled
        case .requestBuildFailed:
            return .requestBuildFailed
        case .tls:
            return .securityError
        case .unknown:
            return .unknown
        }
    }
}

extension DataSourceSupport {
    func handleHttpResult(_ result: Result<HTTPResponse, RemoteDataSourceError>) throws -> HTTPResponse {
        if case .failure(let failure) = result {
            throw failure
        }

        let httpResponse: HTTPResponse = try {
            do {
                return try result.get()
            } catch {
                DebugAssert.fail(category: .network, "Unexpected error: \(error)")
                throw RemoteDataSourceError.unexpected
            }
        }()

        return httpResponse
    }

    func decodeHttpResult<T: Decodable>(_ result: Result<HTTPResponse, RemoteDataSourceError>) throws -> T {
        let httpResponse = try self.handleHttpResult(result)
        return try decodeResponse(httpResponse)
    }
}
