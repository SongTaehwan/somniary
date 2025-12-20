//
//  AuthErrorContext.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//


import Foundation

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