//
//  AppleLoginError.swift
//  Somniary
//
//  Created by 송태환 on 10/11/25.
//

import Foundation

@available(*, deprecated, message: "UseCaseError 로 편입될 계획")
typealias AppleLoginError = SomniaryError<AppleLoginErrorDescriptor, AppleLoginErrorContext>

extension AppleLoginError {
    static func from(
        _ error: Error,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) -> Self {
        return AppleLoginError(
            category: .init(from: error),
            context: .init(
                errorSnapshot: .init(from: error),
                file: file,
                function: function,
                line: line
            )
        )
    }

    static func invalidResponse(
        snapshot: ErrorSnapshot = .unknown,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) -> Self {
        return AppleLoginError(
            category: .invalidResponse,
            context: .init(
                errorSnapshot: snapshot,
                file: file,
                function: function,
                line: line
            )
        )
    }

    static func missingNonce(
        snapshot: ErrorSnapshot = .unknown,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) -> Self {
        return AppleLoginError(
            category: .missingNonce,
            context: .init(
                errorSnapshot: snapshot,
                file: file,
                function: function,
                line: line
            )
        )
    }
}
