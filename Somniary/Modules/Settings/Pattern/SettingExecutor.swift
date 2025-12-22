//
//  SettingExecutor.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import Foundation

final class SettingExecutor: EffectExecuting {

    init() {
        // TODO: Add Deps
    }

    func perform(_ plan: SettingEffectPlan, send: @escaping (SettingIntent) -> Void) {
        switch plan.type {
        case .updateProfile:
            // TODO: Start usecase
            send(.systemInternal(.profileUpdateResponse))
            break
        case .getProfile:
            // TODO: Start usecase
            send(.systemInternal(.profileResponse))
            break
        case .logout:
            TokenRepository.shared.clear()
            // TODO: Start logout usecase
            send(.systemInternal(.logoutResponse))
        case .logEvent(let message):
            print(message)
            break
        default:
            break
        }
    }
}
