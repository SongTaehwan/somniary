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

    private let client: any HTTPNetworking<AuthEndpoint>

    init(client: any HTTPNetworking<AuthEndpoint>) {
        self.client = client
    }

    func requestOtpCode(email: String, createUser: Bool, idempotencyKey: String?) async throws -> VoidResponse {
        let result = await client.request(.requestOtpCode(email: email, createUser: createUser))

        switch result {
        case .success(let response):
            return try JSONDecoder().decode(VoidResponse.self, from: response.body!)
        case .failure(let error):
            throw mapToDomainError(error)
        }
    }

    func verify(email: String, otpCode: String, idempotencyKey: String?) async throws -> TokenEntity {
        let result = await client.request(.verify(email: email, otpCode: otpCode))

        switch result {
        case .success(let response):
            let data = try JSONDecoder().decode(NetAuth.Verify.Response.self, from: response.body!)
            return TokenEntity(accessToken: data.accessToken, refreshToken: data.refreshToken)
        case .failure(let error):
            throw mapToDomainError(error)
        }
    }

    func verify(credential: AppleCredential, idempotencyKey: String?) async throws -> TokenEntity {
        let result = await client.request(.authenticateWithApple(creadential: credential))

        switch result {
        case .success(let response):
            let data = try JSONDecoder().decode(NetAuth.Verify.Response.self, from: response.body!)
            return TokenEntity(accessToken: data.accessToken, refreshToken: data.refreshToken)
        case .failure(let error):
            throw mapToDomainError(error)
        }
    }

    private func mapToDomainError(_ error: Error) -> DomainError {
        fatalError("not implemented")
    }
}
