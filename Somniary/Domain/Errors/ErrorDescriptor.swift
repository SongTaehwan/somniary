//
//  ErrorDescriptor.swift
//  Somniary
//
//  Created by 송태환 on 10/15/25.
//

import Foundation

enum DomainType: String {
    case auth
    case diary
    case profile
    case network
}

protocol ErrorDescriptor: RawRepresentable where RawValue == String {
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
            errorType: rawValue,
            userMessage: userMessage,
            message: errorMessage,
            severity: severity,
            timestamp: context.timestamp,
            metadata: context.metadata
        )
    }
}
