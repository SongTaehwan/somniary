//
//  LoginReducer.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

fileprivate func reduceLifecycleIntent(
    state: LoginViewModel.LoginState,
    intent: LoginIntent.LifecycleIntent,
    env: LoginReducerEnvironment
) -> (LoginViewModel.LoginState, [LoginEffectPlan]) {
    switch intent {
    case .appeared:
        return (state, [])
    case .disappeared:
        return (state, [])
    }
}

fileprivate func reduceUserIntent(
    state: LoginViewModel.LoginState,
    intent: LoginIntent.UserIntent,
    env: LoginReducerEnvironment
) -> (LoginViewModel.LoginState, [LoginEffectPlan]) {
    var newState = state

    switch intent {
    case .emailChanged(let text):
        newState.email = text
        newState.errorMessage = nil
        return (newState, [])

    case .otpCodeChanged(let text):
        newState.otpCode = text
        newState.errorMessage = nil
        return (newState, [])

    case .loginTapped:
        guard newState.email.isValidEmail else {
            return (newState, [
                .toast("올바른 이메일이 아닙니다."),
                .logEvent("invalid_email")
            ])
        }

        return (newState, [
            .updateInputs(otpCode: ""),
            .route(.navigateOtpVerification),
            .logEvent("navigate_otp_verification")
        ])

    case .signUpTapped:
        newState.email = ""
        newState.otpCode = ""
        return (newState, [
            .updateInputs(email: "", otpCode: ""),
            .route(.navigateSignUp),
            .logEvent("navigate_sign_up")
        ])

    case .requestOtpCodeTapped:
        let requestId = newState.latestRequestId ?? env.makeRequestId()
        return (newState, [
            .verify(email: newState.email, requestId: requestId),
            .logEvent("request_otp_code")
        ])

    case .appleSignInTapped:
        // TODO: SDK 연동
        return (newState, [.logEvent("implementation required")])

    case .googleSignInTapped:
        // TODO: SDK 연동
        return (newState, [.logEvent("implementation required")])

    case .signupCompletionTapped:
        return (newState, [
            .route(.navigateHome),
            .logEvent("login_flow_completed")
        ])

    case .submitSignup:
        guard newState.canSubmit else {
            return (newState, [.toast("입력 값을 확인해주세요")])
        }

        let requestId = newState.latestRequestId ?? env.makeRequestId()
        newState.latestRequestId = requestId
        newState.isLoading = true
        return (newState, [.signup(email: newState.email, otpCode: newState.otpCode, requestId: requestId)])

    case .submitLogin:
        guard newState.canSubmit else {
            return (newState, [.toast("입력 값을 확인해주세요")])
        }

        let requestId = newState.latestRequestId ?? env.makeRequestId()
        newState.latestRequestId = requestId
        newState.isLoading = true
        return (newState, [.login(email: newState.email, otpCode: newState.otpCode, requestId: requestId)])
    }
}

fileprivate func reduceExternalIntent(
    state: LoginViewModel.LoginState,
    intent: LoginIntent.ExtenralIntent,
    env: LoginReducerEnvironment
) -> (LoginViewModel.LoginState, [LoginEffectPlan]) {
    return (state, [])
}

fileprivate func reduceInternalIntent(
    state: LoginViewModel.LoginState,
    intent: LoginIntent.InternalIntent,
    env: LoginReducerEnvironment
) -> (LoginViewModel.LoginState, [LoginEffectPlan]) {
    var newState = state

    switch intent {
    case .loginResponse(let result):
        newState.isLoading = false
        newState.latestRequestId = nil

        switch result {
        case .success:
            return (newState, [.route(.navigateHome)])

        case .failure(let error):
            newState.errorMessage = error.readableMessage
            return (newState, [.toast(error.readableMessage)])
        }
    case .signupResponse(let result):
        newState.isLoading = false
        newState.latestRequestId = nil

        switch result {
        case .success:
            return (newState, [.route(.navigateSignupCompletion)])

        case .failure(let error):
            newState.errorMessage = error.readableMessage
            return (newState, [.toast(error.readableMessage)])
        }

    case .verifyResponse(let result):
        switch result {
        case .success:
            return (newState, [.toast("이메일 발송 완료")])
        case .failure(let error):
            newState.errorMessage = error.readableMessage
            return (newState, [.toast(error.readableMessage)])
        }
    }
}

fileprivate func reduceNavigationIntent(
    state: LoginViewModel.LoginState,
    intent: LoginIntent.NavigationIntent,
    env: LoginReducerEnvironment
) -> (LoginViewModel.LoginState, [LoginEffectPlan]) {
    switch intent {
    case .routeToHome:
        return (state, [.route(.navigateHome)])
    case .routeToSignUp:
        return (state, [.route(.navigateSignUp)])
    case .routeToVerification:
        return (state, [.route(.navigateOtpVerification)])
    case .routeToSignUpCompletion:
        return (state, [.route(.navigateSignupCompletion)])
    }
}

struct LoginReducerEnvironment {
    // TODO: 정책 추가
//    let policies: Any
    let makeRequestId: () -> UUID
}

func combinedReducer(
    state: LoginViewModel.LoginState,
    intent: LoginIntent,
    env: LoginReducerEnvironment
) -> (LoginViewModel.LoginState, [LoginEffectPlan]) {
    switch intent {
    case .lifecycle(let intent):
        return reduceLifecycleIntent(state: state, intent: intent, env: env)
    case .user(let intent):
        return reduceUserIntent(state: state, intent: intent, env: env)
    case .systemExtenral(let intent):
        return reduceExternalIntent(state: state, intent: intent, env: env)
    case .systemInternal(let intent):
        return reduceInternalIntent(state: state, intent: intent, env: env)
    case .navigation(let intent):
        return reduceNavigationIntent(state: state, intent: intent, env: env)
    }
}
