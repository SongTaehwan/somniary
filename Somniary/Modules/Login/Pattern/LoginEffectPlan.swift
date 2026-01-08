//
//  LoginEffect.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

/// 무엇을 할지가 아닌 어떻게 할지에 초점
struct LoginEffectPlan: EffectPlan {
    enum EffectType: Equatable {
        /// API effect
        case requestLoginCode(email: String, requestId: UUID)
        case requestSignupCode(email: String, requestId: UUID)
        case verify(email: String, otpCode: String, requestId: UUID)

        /// SDK
        case authenticateWithApple(credential: AppleCredential, requestId: UUID)

        /// side effect
        case logEvent(String)

        /// one-off UI outputs, ViewModel 에 의해 처리됨
        case showToast(String)
        case updateTextField(email: String?, otpCode: String?)

        /// one-off navigations, ViewModel 에 의해 처리됨
        case navigateHome
        case navigateSignUp
        case navigateOtpVerification
        case navigateSignupCompletion
    }

    let type: EffectType

    // TODO: 정책 관련 설정 값 추가
    // 1. 에러 처리 전략
    // 2. 동시성 처리 정책 (직렬, 동시 실행 개수 제한, 최신 요청만 유효(기존 취소), 디바운싱)
    // 3. 캐싱 정책
    // 4. 보안 관련 정책 (로그인 시도 횟수 제한)
    // 5. UX 정책 (로딩 인디케이터 표시, 최소 로딩 시간, 햅틱, 토스트 지속시간 등)
    // 6. 네트워크 정책 (WiFi 필수 여부, 데이터 압축, 우선순위)
    // 7. 로깅/분석 정책 (데이터 익명화, 디아비스 정보 포함, 사용자 이벤트 추적, 로그 레벨 등)

    /// 네트워크 오류로 인한 실패 시 재시도 횟수
    let retryOnNetworkError: Int
    /// Executor 가 긴 작업 진행 시 타임아웃(milliseconds)
    let timeout: Int

    static func make(_ type: EffectType, retry: Int = 0, timeout: Int = 0) -> Self {
        return .init(
            type: type,
            retryOnNetworkError: retry,
            timeout: timeout
        )
    }
}

// MARK: Convenience helers
extension LoginEffectPlan {
    static func toast(_ message: String) -> Self {
        return .make(.showToast(message))
    }

    static func route(_ type: EffectType) -> Self {
        precondition({
            switch type {
            case .navigateHome, .navigateSignUp, .navigateOtpVerification, .navigateSignupCompletion:
                return true
            default:
                return false
            }
        }(), "route(_:) must be used with a navigation effect type")

        return .make(type)
    }

    static func requestLoginCode(
        email: String,
        requestId: UUID, 
        retry: Int = 0,
        timeout: Int = 0
    ) -> Self {
        return .make(
            .requestLoginCode(
                email: email,
                requestId: requestId
            ),
            retry: retry,
            timeout: timeout
        )
    }

    static func requestSignupCode(
        email: String,
        requestId: UUID,
        retry: Int = 0,
        timeout: Int = 0
    ) -> Self {
        return .make(
            .requestSignupCode(
                email: email,
                requestId: requestId
            ),
            retry: retry,
            timeout: timeout
        )
    }

    static func verify(
        email: String,
        otpCode: String,
        requestId: UUID,
        retry: Int = 0,
        timeout: Int = 0
    ) -> Self {
        return .make(
            .verify(
                email: email,
                otpCode: otpCode,
                requestId: requestId
            ),
            retry: retry,
            timeout: timeout
        )
    }

    static func logEvent(_ message: String, level: EffectLogLevel = EffectLogLevel.info) -> Self {
        let log = "[\(level.rawValue)] \(message)"
        return .make(.logEvent(log))
    }

    static func logEvent(message: String = "Error Logging Event", errorMessage: String) -> Self {
        let log =
        """
        --------------------------------------
        [\(EffectLogLevel.error.rawValue)] \(message)
        \(errorMessage)
        --------------------------------------
        """

        return .make(.logEvent(log))
    }

    static func updateTextField(email: String? = nil, otpCode: String? = nil) -> Self {
        return .make(.updateTextField(email: email, otpCode: otpCode))
    }

    static func authenticateWithApple(
        credential: AppleCredential,
        requestId: UUID,
        retry: Int = 0,
        timeout: Int = 10000
    ) -> Self {
        return .make(
            .authenticateWithApple(
                credential: credential,
                requestId: requestId
            ),
            retry: retry,
            timeout: timeout
        )
    }
}
