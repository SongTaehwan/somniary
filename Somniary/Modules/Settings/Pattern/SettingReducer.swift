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
fileprivate typealias Environment = SettingReducerEnvironment

fileprivate func reduceLicycleIntent(
    state: State,
    intent: Intent.LifecycleIntent,
    env: Environment
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
    intent: Intent.UserIntent,
    env: Environment
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
    intent: Intent.SystemExtenralIntent,
    env: Environment
) -> (State, [Plan]) {
    fatalError("implement required")
}

fileprivate func reduceSystemInternalIntent(
    state: State,
    intent: Intent.SystemInternalIntent,
    env: Environment
) -> (State, [Plan]) {
    switch intent {
    case .logoutResponse(let response):
        if case .failure(let error) = response {
            let resolution = env.useCaseResolutionResolver.resolve(error)
            #if DEBUG
            resolution.debugPrint()
            #endif
            return apply(resolution, state: state)
        }

        return (state, [
            .logEvent("Redirect to login flow"),
            .route(.finishFlow)
        ])
    case .profileResponse(let response):
        // TODO: Update state with profile
        if case .failure(let error) = response {
            let resolution = env.useCaseResolutionResolver.resolve(error)
            #if DEBUG
            resolution.debugPrint()
            #endif
            return apply(resolution, state: state)
        }

        return (state, [
            .logEvent("Store fetched profile")
        ])
    case .profileUpdateResponse(let response):
        if case .failure(let error) = response {
            let resolution = env.useCaseResolutionResolver.resolve(error)
            #if DEBUG
            resolution.debugPrint()
            #endif
            return apply(resolution, state: state)
        }

        return (state, [
            .logEvent("Update profile done")
        ])
    }
}

func combinedSettingReducer(
    state: SettingViewModel.State,
    intent category: SettingIntent,
    env: SettingReducerEnvironment
) -> (SettingViewModel.State, [SettingEffectPlan]) {
    switch category {
    case .lifecycle(let intent):
        return reduceLicycleIntent(state: state, intent: intent, env: env)
    case .user(let intent):
        return reduceUserIntent(state: state, intent: intent, env: env)
    case .systemExtenral(let intent):
        return reduceSystemExternalIntent(state: state, intent: intent, env: env)
    case .systemInternal(let intent):
        return reduceSystemInternalIntent(state: state, intent: intent, env: env)
    }
}

fileprivate func apply(
    _ resolution: UseCaseResolution,
    state: State
) -> (state: State, effects: [Plan]) {
    var newState = state
    var effects: [Plan] = []

    switch resolution {
    case .inform(let message):
        newState.errorMessage = message
        effects += [.toast(message)]

    case .retry(let message, _):
        newState.errorMessage = message
        effects += [.toast(message)]

    case .cooldown(let seconds, let message):
        let text: String
        if let seconds {
            text = "\(message) (\(seconds)s)"
        } else {
            text = message
        }
        newState.errorMessage = text
        effects += [.toast(text)]

    case .contactSupport(let message, _):
        newState.errorMessage = message
        effects += [.toast(message)]

    case .updateApp(message: let message, _):
        newState.errorMessage = message
        effects += [.toast(message)]

    case .reauth(mode: let mode, message: let message, _):
        newState.errorMessage = message
        effects += [.toast(message)]

    case .accessDenied(message: let message, _):
        newState.errorMessage = message
        effects += [.toast(message)]
    }

    return (newState, effects)
}
