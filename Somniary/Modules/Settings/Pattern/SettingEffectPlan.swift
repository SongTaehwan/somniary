//
//  SettingEffectPlan.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import Foundation

struct SettingEffectPlan: EffectPlan {
    enum EffectType: Equatable {
        // UI Effect
        case showToast(String)

        // System Output
        case logEvent(String)

        // Navigation
        case navigateToEntry
        case navigateToProfileEdit
        case navigateToNotificationSetting
        case finish
    }

    let type: EffectType

    static func make(_ type: EffectType) -> Self {
        return .init(type: type)
    }
}

extension SettingEffectPlan {
    static func toast(_ message: String) -> Self {
        return .make(.showToast(message))
    }

    static func route(_ type: EffectType) -> Self {
        precondition({
            switch type {
            case .navigateToProfileEdit, .navigateToNotificationSetting:
                return true
            default:
                return false
            }
        }(), "route(_:) must be used with a navigation effect type")

        return .make(type)
    }


    static func logEvent(_ message: String, level: EffectLogLevel = EffectLogLevel.info) -> Self {
        let log = "[\(level.rawValue)] \(message)"
        return .make(.logEvent(log))
    }
}
