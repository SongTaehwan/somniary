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

// MARK: 로그 메시지
extension SomniaryError {
    /// DEBUG 모드 시 debugLog, 아니면 structuredLog 반환
    var log: String {
        #if DEBUG
        return self.debugLog
        #else
        return self.structuredLog
        #endif
    }

    var compactLog: String {
        #if DEBUG
        return self.compactDebugLog
        #else
        return self.structuredLog
        #endif
    }

    /// 개발 디버그용 - 풀 버전
    var debugLog: String {
        let errorSnapshot = context.errorSnapshot
        let errorOrigin = context.errorOrigin

        return """
        ╔══════════════════════════════════════════════════════════════
        ║ \(severity.icon) ERROR DETAILS
        ╠══════════════════════════════════════════════════════════════
        ║ 📦 Domain    : \(descriptor.domain.rawValue.uppercased())
        ║ 🎯 Case      : \(descriptor.rawValue)
        ║ 🏷️ Type      : \(String(describing: type(of: self)))
        ╠──────────────────────────────────────────────────────────────
        ║ 💬 User Msg  : \(descriptor.userMessage)
        ╠──────────────────────────────────────────────────────────────
        ║ 💥 Cause     : \(errorSnapshot.typeName)
        ║ 📄 Message   : \(errorSnapshot.message)
        ║ 🔢 Code      : \(errorSnapshot.code ?? "N/A")
        ╠──────────────────────────────────────────────────────────────
        ║ 📍 Location  : \(errorOrigin.fileName):\(errorOrigin.line)
        ║ 🔧 Function  : \(errorOrigin.function)
        ║ ⏰ Time      : \(context.timestamp.formatted(date: .numeric, time: .standard))
        ╠──────────────────────────────────────────────────────────────
        ║ 📎 Metadata  : \(context.metadata.isEmpty ? "None" : "")
        \(context.metadata.map { "║    • \($0.key): \($0.value)" }.joined(separator: "\n"))
        ╚══════════════════════════════════════════════════════════════
        """
    }

    /// 개발 디버그용 - 축소 버전
    var compactDebugLog: String {
        let errorSnapshot = context.errorSnapshot
        let errorOrigin = context.errorOrigin

        return """
            [\(severity.icon) \(descriptor.domain.rawValue.uppercased()).\(descriptor.rawValue)]
               💬 \(descriptor.userMessage)
               💥 \(errorSnapshot.typeName): \(errorSnapshot.message)
               📍 \(errorOrigin.fileName):\(errorOrigin.line) in \(errorOrigin.function)
               ⏰ \(context.timestamp.formatted(date: .numeric, time: .standard))
            """
    }

    /// 시스템 로깅 용 - 파싱 및 필터링
    /// - Note: grep "domain=auth"
    /// - Note: awk -F' | ' '{print $1, $3}'
    var structuredLog: String {
        let errorSnapshot = context.errorSnapshot
        let errorOrigin = context.errorOrigin

        let components = [
            "domain=\(descriptor.domain.rawValue)",
            "error_type=\(String(describing: type(of: descriptor)))",
            "case=\(descriptor.rawValue)",
            "severity=\(severity.rawValue)",
            "origin=\(errorOrigin.fileName):\(errorOrigin.line)",
            "function=\(errorOrigin.function)",
            "underlying=\(errorSnapshot.typeName)",
            "timestamp=\(context.timestamp.ISO8601Format())",
            "metadata=\(context.metadata)"
        ]

        return components.joined(separator: " | ")
    }
}
