//
//  SettingReducer.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import Foundation

fileprivate typealias State = SettingViewModel.State
fileprivate typealias Plan = SettingEffectPlan
fileprivate typealias Intent = SettingIntent

fileprivate func reduceLicycleIntent(
    state: State,
    intent: Intent.LifecycleIntent
) -> (State, [Plan]) {
    switch intent {
    case .appeared:
        return (state, [.logEvent("View Appeared")])
    }
}

fileprivate func reduceUserIntent(
    state: State,
    intent: Intent.UserIntent
) -> (State, [Plan]) {
    switch intent {
    case .profileTapped:
        return (state, [.route(.navigateToProfileEdit)])
    case .notificationSettingTapped:
        return (state, [.route(.navigateToNotificationSetting)])
    case .logoutTapped:
        return (state, [])
    }
}

fileprivate func reduceSystemExternalIntent(
    state: State,
    intent: Intent.SystemExtenralIntent
) -> (State, [Plan]) {
    fatalError("implement required")
}

fileprivate func reduceSystemInternalIntent(
    state: State,
    intent: Intent.SystemInternalIntent
) -> (State, [Plan]) {
    switch intent {
    case .logoutResponse:
        // Go to login flow
        return (state, [.route(.finish)])
    }
}

fileprivate func reduceNavigationIntent(
    state: State,
    intent: Intent.NavigationIntent
) -> (State, [Plan]) {
    switch intent {
    case .routeToHome:
        return (state, [.route(.navigateToEntry)])
    case .routeToProfileEdit:
        return (state, [.route(.navigateToNotificationSetting)])
    case .routeToNotificationSettings:
        return (state, [.route(.navigateToProfileEdit)])
    }
}

func combinedSettingReducer(
    state: SettingViewModel.State,
    intent category: SettingIntent
) -> (SettingViewModel.State, [SettingEffectPlan]) {
    switch category {
    case .lifecycle(let intent):
        return reduceLicycleIntent(state: state, intent: intent)
    case .user(let intent):
        return reduceUserIntent(state: state, intent: intent)
    case .systemExtenral(let intent):
        return reduceSystemExternalIntent(state: state, intent: intent)
    case .systemInternal(let intent):
        return reduceSystemInternalIntent(state: state, intent: intent)
    case .navigation(let intent):
        return reduceNavigationIntent(state: state, intent: intent)
    }
}
