//
//  SomniaryError.swift
//  Somniary
//
//  Created by 송태환 on 10/15/25.
//

import Foundation

struct SomniaryError<Descriptor, Context>: DomainError where Descriptor: ErrorDescriptor, Context: ErrorContext {
    let descriptor: Descriptor
    let context: Context

    init(
        category descriptor: Descriptor,
        context: Context
    ) {
        self.descriptor = descriptor
        self.context = context
    }

    var userMessage: String {
        return descriptor.userMessage
    }

    var severity: ErrorSeverity {
        return descriptor.severity
    }

    func toErrorInfo() -> ErrorInfo {
        return descriptor.toErrorInfo(context: context)
    }
}

extension SomniaryError: Equatable where Descriptor: Equatable, Context: Equatable {
    static func == (lhs: SomniaryError, rhs: SomniaryError) -> Bool {
        lhs.descriptor == rhs.descriptor &&
        lhs.context == rhs.context
    }
}
