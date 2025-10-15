//
//  LoginIntent.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

/// 로그인 Intent
/// - note: 도메인 타입을 사용하여 SDK 등의 의존성을 최소화하는 것을 원칙으로 한다.
internal enum LoginIntent: Equatable {

    // MARK: View Lifecycle
    enum LifecycleIntent: Equatable { case appeared, disappeared }

    // MARK: 푸시, 딥링크, 앱 설정 변경, 네트워크 재연결
    enum SystemExtenralIntent: Equatable {
        case deepLink(URL)
        case networkReachable(Bool)
        case appleLoginRequest
        case appleLoginCompleted(Result<AppleCredential, AppleLoginError>)
    }

    // MARK: Internal(Effect)
    enum SystemInternalIntent: Equatable {
        case loginResponse(Result<VoidResponse, AuthError>)  // 로그인 API 결과 처리
        case signupResponse(Result<VoidResponse, AuthError>) // 회원가입 API 결과 처리
        case verifyResponse(Result<TokenEntity, AuthError>)
    }

    // MARK: User interaction
    enum UserIntent: Equatable {
        case emailChanged(String)
        case otpCodeChanged(String)
        case submitSignup
        case submitLogin
        case signUpTapped
        case loginTapped
        case requestOtpCodeTapped

        case googleSignInTapped // SDK 연결
        case signupCompletionTapped
    }

    // MARK: Navigation
    enum NavigationIntent: Equatable {
        case routeToHome
        case routeToSignUp
        case routeToVerification
        case routeToSignUpCompletion
    }

    // Lifecycle(View)
    case lifecycle(LifecycleIntent)

    // User(Gesture)
    case user(UserIntent)

    // External(System) - 푸시, 딥링크, 앱 설정 변경, 네트워크 재연결
    case systemExtenral(SystemExtenralIntent)

    // Internal(Effect)
    case systemInternal(SystemInternalIntent)

    // Navigation
    case navigation(NavigationIntent)
}
