//
//  SettingViewModel.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import Foundation
import Combine

final class SettingViewModel: BaseViewModel<SettingViewModel.State, SettingEffectPlan, SettingIntent, SettingRoute> {
    struct State: Equatable {
        var profile: UserProfile?
        var errorMessage: String?
    }

    private let environment: SettingEnvironment

    @Published var isToggle = false

    init(coordinator: Coordinator, executor: Executor, environment: SettingEnvironment) {
        self.environment = environment
        super.init(coordinator: coordinator, executor: executor, initialState: State())
        self.binding()
    }

    private func binding() {
        self.$isToggle
            .dropFirst()
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .sink { value in
                if value {
                    self.handle(.user(.notificationOn))
                } else {
                    self.handle(.user(.notificationOff))
                }
            }
            .store(in: &cancellables)

        self.intents
            .sink { intent in
                self.handle(intent)
            }
            .store(in: &cancellables)
    }

    private func handle(_ intent: SettingIntent) {
        let (updatedState, plans) = combinedSettingReducer(state: self.state, intent: intent, env: environment.reducerEnv)

        if self.state != updatedState {
            Task { @MainActor in
                self.state = updatedState
            }
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
                executor.perform(plan, send: self.send)
            }
        }
    }
}
