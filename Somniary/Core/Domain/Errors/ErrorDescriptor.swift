//
//  ErrorDescriptor.swift
//  Somniary
//
//  Created by 송태환 on 10/15/25.
//

import Foundation

protocol ErrorDescriptor: Equatable {
    /// 사용자 메시지
    var userMessage: String { get }

    var severity: ErrorSeverity { get }

    var domain: DomainType { get }

    func toErrorInfo<Context: ErrorContext>(context: Context) -> ErrorInfo
}

extension ErrorDescriptor {
    func toErrorInfo<Context: ErrorContext>(context: Context) -> ErrorInfo {
        let errorMessage = context.errorSnapshot.message

        return ErrorInfo(
            domain: domain.rawValue,
            errorType: String(describing: self),
            userMessage: userMessage,
            message: errorMessage,
            severity: severity,
            timestamp: context.timestamp,
            metadata: context.metadata
        )
    }
}
