//
//  RemoteAuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

enum LoginError: Error, Equatable {
    case invalidEmail
    case invalidPassword
    case networkError
    case serverError(String) // 서버에서 내려주는 메시지
    case unknown

    var readableMessage: String {
        switch self {
        case .invalidEmail:
            return "이메일 형식이 올바르지 않습니다."
        case .invalidPassword:
            return "비밀번호를 확인해주세요."
        case .networkError:
            return "네트워크 오류가 발생했습니다. 다시 시도해주세요."
        case .serverError(let msg):
            return msg
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}

struct RemoteAuthRepository: AuthReposable {

    private let client: any SomniaryNetworking<AuthEndpoint>

    init(client: any SomniaryNetworking<AuthEndpoint>) {
        self.client = client
    }

    func signup(email: String, idempotencyKey: String?) async throws -> VoidResponse {
        let result = try await client.request(.signup(email: email), type: VoidResponse.self)
        return result
    }

    func login(email: String, idempotencyKey: String? = nil) async throws -> VoidResponse {
        let result = try await client.request(.login(email: email), type: VoidResponse.self)
        return result
    }

    func verify(email: String, otpCode: String, type: String) async throws -> Token {
        let result = try await client.request(.verify(email: email, otpCode: otpCode, type: .magiclink), type: Token.self)
        return result
    }
}
