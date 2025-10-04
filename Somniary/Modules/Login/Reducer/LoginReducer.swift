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
        
        return (newState, [.logEvent("email_changed: \(text)")])

    case .otpCodeChanged(let text):
        newState.otpCode = text
        newState.errorMessage = nil

        return (newState, [.logEvent("OTP_code_changed: \(text)")])

    case .loginTapped:
        guard newState.email.isValidEmail else {
            return (newState, [
                .logEvent("invalid_email"),
                .toast("올바른 이메일이 아닙니다.")
            ])
        }

        let requestId = newState.latestRequestId ?? env.makeRequestId()
        newState.otpCode = ""

        return (newState, [
            .logEvent("reset_inputs"),
            .updateTextField(otpCode: ""),
            .logEvent("request_login"),
            .requestLoginCode(email: newState.email, requestId: requestId),
        ])

    case .signUpTapped:
        newState.email = ""
        newState.otpCode = ""

        return (newState, [
            .logEvent("reset_inputs", level: .debug),
            .updateTextField(email: "", otpCode: ""),
            .logEvent("navigate_sign_up"),
            .route(.navigateSignUp)
        ])

    case .requestOtpCodeTapped:
        let requestId = newState.latestRequestId ?? env.makeRequestId()
        newState.step = .otpCode

        return (newState, [
            .logEvent("request_otp_verification"),
            .requestSignupCode(email: newState.email, requestId: requestId),
        ])

    case .appleSignInTapped:
        // TODO: SDK 연동
        return (newState, [.logEvent("apple_signin_implementation_required")])

    case .googleSignInTapped:
        // TODO: SDK 연동
        return (newState, [.logEvent("google_signin_implementation_required")])

    case .signupCompletionTapped:
        return (newState, [
            .logEvent("login_flow_completed"),
            .route(.navigateHome)
        ])

    case .submitSignup:
        guard newState.canSubmit else {
            return (newState, [
                .logEvent("invalid_signup_input"),
                .toast("입력 값을 확인해주세요")
            ])
        }

        let requestId = newState.latestRequestId ?? env.makeRequestId()
        newState.latestRequestId = requestId
        newState.isLoading = true

        return (newState, [
            .logEvent("request_signup"),
            .verify(
                email: newState.email,
                otpCode: newState.otpCode,
                requestId: requestId
            )
        ])

    case .submitLogin:
        guard newState.canSubmit else {
            return (newState, [
                .logEvent("invalid_login_input"),
                .toast("입력 값을 확인해주세요")
            ])
        }

        let requestId = newState.latestRequestId ?? env.makeRequestId()
        newState.latestRequestId = requestId
        newState.isLoading = true

        return (newState, [
            .logEvent("request_login"),
            .verify(
                email: newState.email,
                otpCode: newState.otpCode,
                requestId: requestId
            )
        ])
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
            return (newState,[
                .logEvent("login_success", level: .debug),
                .logEvent("navigate_otp_verification"),
                .route(.navigateOtpVerification)
            ])

        case .failure(let error):
            newState.errorMessage = error.readableMessage
            return (newState, [
                .logEvent("login_failed \(error.readableMessage)", level: .error),
                .toast(error.readableMessage)
            ])
        }
    case .signupResponse(let result):
        newState.isLoading = false
        newState.latestRequestId = nil

        switch result {
        case .success:
            return (newState, [
                .logEvent("signup_success", level: .debug)
            ])

        case .failure(let error):
            newState.errorMessage = error.readableMessage
            return (newState, [
                .logEvent("signup_failed \(error.readableMessage)", level: .error),
                .toast(error.readableMessage)
            ])
        }

    case .verifyResponse(let result):
        switch result {
        case .success(let token):
            return (newState, [
                .logEvent("otp_verification_success", level: .debug),
                .logEvent("navigate_home"),
                .route(.navigateHome)
            ])

        case .failure(let error):
            newState.errorMessage = error.readableMessage
            return (newState, [
                .logEvent("otp_verfication_failed \(error.readableMessage)", level: .error),
                .toast(error.readableMessage),
            ])
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
        return (state, [
            .logEvent("navigate_home"),
            .route(.navigateHome)
        ])

    case .routeToSignUp:
        return (state, [
            .logEvent("navigate_signup"),
            .route(.navigateSignUp)
        ])

    case .routeToVerification:
        return (state, [
            .logEvent("navigate_otp_verification"),
            .route(.navigateOtpVerification)
        ])

    case .routeToSignUpCompletion:
        return (state, [
            .logEvent("navigate_signup_completion"),
            .route(.navigateSignupCompletion)
        ])
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
