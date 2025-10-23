//
//  ErrorSeverity.swift
//  Somniary
//
//  Created by 송태환 on 10/15/25.
//

import Foundation

enum ErrorSeverity: String, Equatable {
    case debug
    case info
    case warning
    case error
    case critical

    var icon: String {
        switch self {
        case .debug:
            return "🐛"
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "💥"
        case .critical:
            return "💀"
        }
    }
}
