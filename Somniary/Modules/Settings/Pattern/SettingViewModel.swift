//
//  SettingViewModel.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import Combine

struct Profile: Equatable {
    let name: String
    let email: String
    let thumbnail: String = "person.crop.circle"
}

final class SettingViewModel: BaseViewModel<SettingViewModel.State, SettingEffectPlan, SettingIntent, SettingRoute> {
    struct State: Equatable {
        var profile: Profile?
    }

    init(coordinator: Coordinator, executor: Executor) {
        super.init(coordinator: coordinator, executor: executor, initialState: State())
        self.binding()
    }

    private func binding() {
        self.intents
            .sink { intent in
                self.handle(intent)
            }
            .store(in: &cancellables)
    }

    private func handle(_ intent: SettingIntent) {
        let (updatedState, plans) = combinedSettingReducer(state: self.state, intent: intent)

        if self.state != updatedState {
            self.state = updatedState
        }

        for plan in plans {
            switch plan.type {
            case .showToast(let message):
                self.uiEvent.send(.toast(message))
            case .navigateToEntry:
                self.coordinator.push(route: .main)
            case .navigateToProfileEdit:
                self.coordinator.push(route: .profile)
            case .navigateToNotificationSetting:
                self.coordinator.push(route: .notification)
            case .finishFlow:
                self.coordinator.finish()
            default:
                print("Execute: \(plan.type)")
                executor.perform(plan, send: self.send)
            }
        }
    }
}
