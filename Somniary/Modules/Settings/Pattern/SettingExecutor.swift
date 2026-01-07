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
                let result = await updateProfileUseCase.execute(.init(id: id, name: name, email: email))
                print("RESULT: \(result)")

                send(.systemInternal(.profileUpdateResponse))
            }
        case .getProfile:
            Task {
                let result = await getProfileUseCase.execute()
                print("RESULT: \(result)")

                send(.systemInternal(.profileResponse))
            }
        case .logout:
            Task {
                let result = await logoutUseCase.execute()
                send(.systemInternal(.logoutResponse(result)))
            }
        case .logEvent(let message):
            print(message)
        default:
            break
        }
    }
}
