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

struct RemoteAuthDataSource: AuthDataSource {

    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func signup(email: String, code: String, idempotencyKey: String?) async throws -> Token {
        Token(accessToken: "123", refreshToken: "321")
    }

    func login(email: String, code password: String, idempotencyKey: String? = nil) async throws -> Token {
        Token(accessToken: "123", refreshToken: "321")
    }

    func verify(email: String) async throws -> VoidResponse {
        return VoidResponse()
    }
}
