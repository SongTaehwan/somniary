//
//  AuthError.swift
//  Somniary
//
//  Created by 송태환 on 10/15/25.
//

import Foundation

enum AuthErrorDescriptor: String, ErrorDescriptor {
    case credentialInvalid
    case tokenExpired
    case serverError
    case unknown

    var userMessage: String {
        switch self {
        case .serverError:
            return "서버 에러가 발생했습니다."
        case .credentialInvalid:
            return "잘못된 계정 정보입니다."
        case .tokenExpired:
            return "토큰이 만료되었습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }

    var severity: ErrorSeverity {
        switch self {
        case .serverError:
            return .critical
        default:
            return .warning
        }
    }

    var domain: DomainType {
        return .auth
    }
}

struct AuthErrorContext: ErrorContext, Equatable {

    enum AuthProvider: String, Equatable {
        case apple
        case google
        case otp
    }

    let provider: AuthProvider?
    let idempotencyKey: String?
    let statusCode: Int?

    // protocol
    let errorSnaphot: ErrorSnapshot?
    let errorOrigin: ErrorOrigin

    var metadata: [String : String] {
        return [
            "provider": provider?.rawValue ?? "",
            "idempotency_key": idempotencyKey ?? "",
            "status_code": statusCode.map(String.init) ?? ""
        ]
    }

    init(
        provider: AuthProvider? = nil,
        idempotencyKey: String? = nil,
        statusCode: Int? = nil,
        errorSnaphot: ErrorSnapshot? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        self.provider = provider
        self.idempotencyKey = idempotencyKey
        self.statusCode = statusCode
        self.errorSnaphot = errorSnaphot
        self.errorOrigin = ErrorOrigin(
            file: file,
            function: function,
            line: line
        )
    }
}

extension AuthErrorContext {
    static func == (lhs: AuthErrorContext, rhs: AuthErrorContext) -> Bool {
        lhs.provider == rhs.provider &&
        lhs.idempotencyKey == rhs.idempotencyKey &&
        lhs.statusCode == rhs.statusCode
    }
}

typealias AuthError = SomniaryError<AuthErrorDescriptor, AuthErrorContext>

extension AuthError {
    static func unknown(
        snapshot: ErrorSnapshot? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) -> Self {
        return AuthError(
            category: .unknown,
            context: .init(
                errorSnaphot: snapshot,
                file: file,
                function: function,
                line: line
            )
        )
    }
}
