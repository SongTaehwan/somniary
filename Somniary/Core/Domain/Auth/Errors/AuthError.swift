//
//  AuthError.swift
//  Somniary
//
//  Created by 송태환 on 10/15/25.
//

import Foundation

/// 특정 도메인 에러 케이스 정의
enum AuthErrorDescriptor: ErrorDescriptor {
    case resourceAlreadyExists
    /// 취소
    case operationCancelled
    /// 인증 필요
    case authenticationRequired
    /// 네트워크 연결 불가
    case networkUnavailable
    /// 서버 오류
    case serverError
    /// 클라이언트 버그 (앱 코드 문제)
    case systemError(reason: String)
    case serviceUnavailable
    case unexpected
    case unknown

    var userMessage: String {
        switch self {
        case .resourceAlreadyExists:
            return "이미 가입된 계정입니다."
        case .operationCancelled:
            return "작업이 취소되었습니다."
        case .authenticationRequired:
            return "로그인이 필요한 서비스 입니다."
        case .networkUnavailable:
            return "네트워크가 연결되지 않았습니다."
        case .serverError:
            return "서버 에러가 발생했습니다."
        case .systemError(let reason):
            return "서비스 오류 발생: \(reason)"
        case .unknown, .unexpected:
            return "알 수 없는 오류가 발생했습니다."
        case .serviceUnavailable:
            return "현재는 사용이 불가능한 서비스입니다."
        }
    }

    var severity: ErrorSeverity {
        switch self {
        case .serverError, .unexpected, .unknown:
            return .critical
        case .systemError, .serviceUnavailable:
            return .error
        case .resourceAlreadyExists, .operationCancelled, .authenticationRequired:
            return .info
        case .networkUnavailable:
            return .warning
        @unknown default:
            return .warning
        }
    }

    var domain: DomainType {
        return .auth
    }
}

struct AuthErrorContext: ErrorContext {
    enum AuthProvider: String, Equatable {
        case apple
        case google
        case otp
    }

    let provider: AuthProvider?
    let idempotencyKey: String?
    let statusCode: Int?

    // protocol
    let errorSnapshot: ErrorSnapshot
    let errorOrigin: ErrorOrigin

    var metadata: [String : String] {
        return [
            "provider": provider?.rawValue ?? "nil",
            "idempotency_key": idempotencyKey ?? "nil",
            "status_code": statusCode.map(String.init) ?? "nil"
        ]
    }

    init(
        provider: AuthProvider? = nil,
        idempotencyKey: String? = nil,
        statusCode: Int? = nil,
        errorSnapshot: ErrorSnapshot = .unknown,
        file: String,
        function: String,
        line: Int
    ) {
        self.provider = provider
        self.idempotencyKey = idempotencyKey
        self.statusCode = statusCode
        self.errorSnapshot = errorSnapshot
        self.errorOrigin = ErrorOrigin(
            file: file,
            function: function,
            line: line
        )
    }
}

typealias AuthError = SomniaryError<AuthErrorDescriptor, AuthErrorContext>

extension AuthError {
    init(
        category: AuthErrorDescriptor,
        message: String = "",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        self.init(
            category: category,
            context: .init(
                provider: nil,
                idempotencyKey: nil,
                statusCode: nil,
                errorSnapshot: ErrorSnapshot(typeName: "AuthError", message: message),
                file: file,
                function: function,
                line: line
            )
        )
    }

    static func unexpected(
        snapshot: ErrorSnapshot = .unknown,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) -> Self {
        return AuthError(
            category: .unexpected,
            context: .init(
                errorSnapshot: snapshot,
                file: file,
                function: function,
                line: line
            )
        )
    }

    static func unknown(
        snapshot: ErrorSnapshot = .unknown,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) -> Self {
        return AuthError(
            category: .unknown,
            context: .init(
                errorSnapshot: snapshot,
                file: file,
                function: function,
                line: line
            )
        )
    }
}
