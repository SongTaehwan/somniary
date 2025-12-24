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
        return (state, [
            .logEvent("Start Fetching profile"),
            .make(.getProfile),
            .logEvent("End Fetching profile")
        ])
    }
}

fileprivate func reduceUserIntent(
    state: State,
    intent: Intent.UserIntent
) -> (State, [Plan]) {
    switch intent {
    case .profileTapped:
        return (state, [
            .logEvent("Navigate To Profile Edit"),
            .route(.navigateToProfileEdit)
        ])
    case .notificationSettingTapped:
        return (state, [
            .logEvent("Navigate To Notification Setting"),
            .route(.navigateToNotificationSetting),
        ])
    case .logoutTapped:
        return (state, [
            .logEvent("Start logout"),
            .make(.logout),
            .logEvent("End logout")
        ])
    case .profileEditConfirmTapped:
        guard let profile = state.profile else {
            var newState = state
            newState.errorMessage = "프로필 정보를 찾을 수 없습니다."
            return (state, [
                .logEvent("profile is nil in state")
            ])
        }

        return (state, [
            .logEvent("Start updating profile"),
            .make(.updateProfile(id: profile.id, name: profile.name, email: profile.email)),
            .logEvent("End updating profile")
        ])
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
    var newState = state

    switch intent {
    case .logoutResponse(let response):
        if case .failure(let failure) = response {
            newState.errorMessage = failure.userMessage
            return (newState, [
                .logEvent(failure.debugLog)
            ])
        }

        return (state, [
            .logEvent("Redirect to login flow"),
            .route(.finishFlow)
        ])
    case .profileResponse:
        // TODO: Update state with profile
        return (state, [
            .logEvent("Store fetched profile")
        ])
    case .profileUpdateResponse:
        return (state, [
            .logEvent("Update profile done")
        ])
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
    }
}
