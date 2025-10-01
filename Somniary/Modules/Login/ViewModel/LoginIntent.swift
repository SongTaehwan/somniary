//
//  LoginIntent.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

// MARK: Intent
internal enum LoginIntent: Equatable {

    // MARK: View Lifecycle
    enum LifecycleIntent: Equatable { case appeared, disappeared }

    // MARK: 푸시, 딥링크, 앱 설정 변경, 네트워크 재연결
    enum ExtenralIntent: Equatable { case deepLink(URL), networkReachable(Bool) }

    // MARK: Internal(Effect)
    enum InternalIntent: Equatable {
        case loginResponse(Result<Token, LoginError>)  // 로그인 API 결과 처리
        case signupResponse(Result<Token, LoginError>) // 회원가입 API 결과 처리
        case verifyResponse(Result<VoidResponse, LoginError>)
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

        case appleSignInTapped // SDK 연결
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
    case systemExtenral(ExtenralIntent)

    // Internal(Effect)
    case systemInternal(InternalIntent)

    // Navigation
    case navigation(NavigationIntent)
}
