//
//  DebugSeverity.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

/// 디버그 심각도
enum DebugSeverity: String, Codable {
    case info = "ℹ️"
    case warning = "⚠️"
    case error = "❌"
    case critical = "🚨"
}
