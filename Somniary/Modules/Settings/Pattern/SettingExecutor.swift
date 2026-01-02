//
//  SettingExecutor.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import Foundation

final class SettingExecutor: EffectExecuting {
    private let logoutUseCase: LogoutUseCase
    private let getProfileUseCase: GetProfileUseCase
    private let updateProfileUseCase: UpdateProfileUseCase

    init(logoutUseCase: LogoutUseCase, getProfileUseCase: GetProfileUseCase, updateProfileUseCase: UpdateProfileUseCase) {
        self.logoutUseCase = logoutUseCase
        self.getProfileUseCase = getProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
    }

    func perform(_ plan: SettingEffectPlan, send: @escaping (SettingIntent) -> Void) {
        switch plan.type {
        case let .updateProfile(id, name, email):
            Task {
                let result = await Result.catching {
                    try await updateProfileUseCase.execute(.init(id: id, name: name, email: email))
                } mapError: { error in
                    error
                }

                print("RESULT: \(result)")

                send(.systemInternal(.profileUpdateResponse))
            }
        case .getProfile:
            Task {
                let result = await Result.catching {
                    try await getProfileUseCase.execute()
                } mapError: { error in
                    error
                }

                print("RESULT: \(result)")

                send(.systemInternal(.profileResponse))
            }
        case .logout:
            handleLogout { result in
                send(.systemInternal(.logoutResponse(result)))
            }
        case .logEvent(let message):
            print(message)
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
