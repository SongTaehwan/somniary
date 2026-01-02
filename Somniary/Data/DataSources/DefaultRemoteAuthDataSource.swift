//
//  DefaultRemoteAuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 10/25/25.
//

import Foundation

/// 책임: 네트워크 프로토콜 해석
/// 1. DTO Decoding/Encoding
/// 2. 전송 계층 에러를 data source 에러로 매핑
struct DefaultRemoteAuthDataSource: RemoteAuthDataSource, DataSourceSupport {
    private let client: any HTTPNetworking<AuthEndpoint>
    private let decorder = JSONDecoder()

    init(client: any HTTPNetworking<AuthEndpoint>) {
        self.client = client
    }

    func requestOtpCode(payload: NetAuth.OTP.Request, idempotencyKey: String?) async -> Result<Void, DataSourceError> {
        let httpResult = await client.request(.requestOtpCode(payload: payload))
        return handleTransportResult(httpResult)
    }

    func verify(payload: NetAuth.Email.Request, idempotencyKey: String?) async -> Result<NetAuth.Email.Response, DataSourceError> {
        let httpResult = await client.request(.verify(payload: payload))
        return handleTransportResult(httpResult)
    }

    func verify(payload: NetAuth.Apple.Request, idempotencyKey: String?) async -> Result<NetAuth.Apple.Response, DataSourceError> {
        let httpResult = await client.request(.authenticateWithApple(payload: payload))
        return handleTransportResult(httpResult)
    }

    func logout() async -> Result<Void, DataSourceError> {
        let httpResult = await client.request(.logout)
        return handleTransportResult(httpResult)
    }
}
