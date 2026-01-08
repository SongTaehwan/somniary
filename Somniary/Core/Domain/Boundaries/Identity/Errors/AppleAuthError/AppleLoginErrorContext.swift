//
//  AppleLoginErrorContext.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//


import Foundation

struct AppleLoginErrorContext: ErrorContext, Equatable {
    let errorSnapshot: ErrorSnapshot
    let errorOrigin: ErrorOrigin

    init(
        errorSnapshot: ErrorSnapshot = .unknown,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        self.errorSnapshot = errorSnapshot
        self.errorOrigin = ErrorOrigin(
            file: file,
            function: function,
            line: line
        )
    }
}
