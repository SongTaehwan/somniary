//
//  SettingExecutor.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import Foundation

final class SettingExecutor: EffectExecuting {
    private let logoutUseCase: LogoutUseCase

    init(logoutUseCase: LogoutUseCase) {
        self.logoutUseCase = logoutUseCase
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
            handleLogout { result in
                send(.systemInternal(.logoutResponse(result)))
            }
        case .logEvent(let message):
            print(message)
            break
        default:
            break
        }
    }

    private func handleLogout(callback: @escaping (Result<VoidResponse, AuthError>) -> Void) {
        Task {
            let result = await Result.catching {
                try await logoutUseCase.execute()
            } mapError: { error in
                error as? AuthError ?? .unknown()
            }

            callback(result)
        }
    }
}
