//
//  EffectPlan.swift
//  Somniary
//
//  Created by 송태환 on 12/21/25.
//

import Foundation

enum EffectLogLevel: String {
    case debug = "🐛"
    case info = "ℹ️"
    case error = "🚨"
    case warning = "⚠️"
}

protocol EffectPlan: Equatable {
    associatedtype EffectType: Equatable

    static func toast(_ message: String) -> Self
    static func route(_ type: EffectType) -> Self
    static func logEvent(_ message: String, level: EffectLogLevel) -> Self
}
