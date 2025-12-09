//
//  DefaultRemoteAuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 10/25/25.
//

import Foundation

/// 책임: 네트워크 프로토콜 해석
/// 1. Decoding/Encoding
/// 2. 전송 계층 에러를 data source 에러로 매핑
struct DefaultRemoteAuthDataSource: RemoteAuthDataSource, DataSourceSupport {
    private let client: any HTTPNetworking<AuthEndpoint>
    private let decorder: JSONDecoder

    init(client: any HTTPNetworking<AuthEndpoint>, decorder: JSONDecoder = .init()) {
        self.client = client
        self.decorder = decorder
    }

    private func handleHttpResult<T: Decodable>(_ result: Result<HTTPResponse, RemoteDataSourceError>) throws -> T {
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

        return try self.decodeResponse(httpResponse)
    }

    func requestOtpCode(payload: NetAuth.OTP.Request, idempotencyKey: String?) async throws -> NetCommon.Void {
        let httpResult = await client.request(.requestOtpCode(payload: payload))
            .mapError { self.mapTransportError($0) }
        return try handleHttpResult(httpResult)
    }

    func verify(payload: NetAuth.Email.Request, idempotencyKey: String?) async throws -> NetAuth.Email.Response {
        let httpResult = await client.request(.verify(payload: payload))
            .mapError { self.mapTransportError($0) }
        return try handleHttpResult(httpResult)
    }

    func verify(payload: NetAuth.Apple.Request, idempotencyKey: String?) async throws -> NetAuth.Apple.Response {
        let httpResult = await client.request(.authenticateWithApple(payload: payload))
            .mapError { self.mapTransportError($0) }
        return try handleHttpResult(httpResult)
    }
}
