//
//  RemoteAuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

/// 역할: Data 레이어 계층 모델을 Domain 모델로 변환
/// '데이터 접근을 조율'하고, 복잡한 변환은 위임하고 간단한 작업은 직접 처리하여 Domain Entity 제공
///
/// 1. DTO 를 Domain 객체로 매핑
/// 2. Data source error 를 Domain error 로 매핑
struct RemoteAuthRepository: AuthRepository {
    private let client: any HTTPNetworking<AuthEndpoint>

    init(client: any HTTPNetworking<AuthEndpoint>) {
        self.client = client
    }

    func requestOtpCode(email: String, createUser: Bool, idempotencyKey: String?) async throws -> VoidResponse {
//        let result = await client.request(.requestOtpCode(email: email, createUser: createUser))
//
//        switch result {
//        case .success(let response):
//            return try JSONDecoder().decode(VoidResponse.self, from: response.body!)
//        case .failure(let error):
//            throw mapToDomainError(error)
//        }

        fatalError("not implemented")
    }

    func verify(email: String, otpCode: String, idempotencyKey: String?) async throws -> TokenEntity {
//        let result = await client.request(.verify(email: email, otpCode: otpCode))
//
//        switch result {
//        case .success(let response):
//            let data = try JSONDecoder().decode(NetAuth.Verify.Response.self, from: response.body!)
//            return TokenEntity(accessToken: data.accessToken, refreshToken: data.refreshToken)
//        case .failure(let error):
//            throw mapToDomainError(error)
//        }

        fatalError("not implemented")
    }

    func verify(credential: AppleCredential, idempotencyKey: String?) async throws -> TokenEntity {
//        let result = await client.request(.authenticateWithApple(payload: credential))
//
//        switch result {
//        case .success(let response):
//            let data = try JSONDecoder().decode(NetAuth.Email.Response.self, from: response.body!)
//            return TokenEntity(accessToken: data.accessToken, refreshToken: data.refreshToken)
//        case .failure(let error):
//            throw mapToDomainError(error)
//        }
        fatalError("not implemented")
    }

    private func mapToDomainError(_ error: Error) -> DomainError {
        fatalError("not implemented")
    }
}
