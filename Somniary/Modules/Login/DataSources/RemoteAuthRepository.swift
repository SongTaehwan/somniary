//
//  RemoteAuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

/// 도메인 객체로 변환 담당
// TODO: API 별로 Infra Error 객체를 Domain Error 객체로 매핑
struct RemoteAuthRepository: AuthReposable {

    private let client: any SomniaryNetworking<AuthEndpoint>

    init(client: any SomniaryNetworking<AuthEndpoint>) {
        self.client = client
    }

    func requestOtpCode(email: String, createUser: Bool, idempotencyKey: String?) async throws -> VoidResponse {
        let result = try await client.request(.requestOtpCode(email: email, createUser: createUser), type: VoidResponse.self)
        return result
    }

    func verify(email: String, otpCode: String, idempotencyKey: String?) async throws -> TokenEntity {
        let result = try await client.request(.verify(email: email, otpCode: otpCode), type: NetAuth.Verify.Response.self)
        return TokenEntity(accessToken: result.accessToken, refreshToken: result.refreshToken)
    }

    func verify(credential: AppleCredential, idempotencyKey: String?) async throws -> TokenEntity {
        let result = try await client.request(.authenticateWithApple(creadential: credential), type: NetAuth.Verify.Response.self)
        return TokenEntity(accessToken: result.accessToken, refreshToken: result.refreshToken)
    }
}
