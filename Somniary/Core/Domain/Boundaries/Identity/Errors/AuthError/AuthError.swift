//
//  AuthError.swift
//  Somniary
//
//  Created by 송태환 on 10/15/25.
//

import Foundation

@available(*, deprecated, message: "로그용 에러 객체로 대체")
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
