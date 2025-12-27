//
//  AuthDomainError.swift
//  Somniary
//
//  Created by 송태환 on 12/25/25.
//

import Foundation

enum AuthDomainError: Error, Equatable {
    /// 1. 토큰 만료 등으로 세션 복구가 필요한 케이스
    /// - Access Token 만료
    /// - 서버 정책으로 인한 만료
    /// 2. 토큰이 유효하지 않거나 인증/재인증이 필요한 경우
    /// - 토큰이 깨짐/변조/서명 불일치
    /// - 로그아웃/강제 만료/리보크됨
    /// - 다른 환경(스테이징/프로덕션) 토큰 섞임
    /// - 클라이언트 버그로 잘못된 토큰 저장/전송
    case authRequired(reason: AuthRequiredReason)

    /// 인증은 되었으나 권한/스코프가 부족함
    case permissionDenied(reason: PermissionDeniedReason)

    /// 계정/세션이 정책적으로 제한됨 (정지/탈퇴/차단 등)
    case accountRestricted(reason: AccountRestrictedReason)

    /// 기존 인증 세션 복구가 불가능한 케이스
    enum AuthRequiredReason: Error, Equatable {
        // Access Token
        case accessTokenInvalid
        case accessTokenRevoked
        case accessTokenExpired

        // Refresh Token
        case refreshTokenInvalid
        case refreshTokenExpired
        case refreshTokenRevoked
        case refreshTokenMissing

        // Account
        case credentialChanged

        // 환경/클라이언트 문제
        case clientMisconfigured
    }

    enum PermissionDeniedReason: Error, Equatable {
        /// 인증은 되었지만, 토큰에 포함된 scope/permission 집합이 해당 리소스를 호출하기에 부족한 상태
        /// 원인:
        /// - 서버가 새 권한을 요구하도록 바뀌었는데 기존 토큰이 구권한만 가짐
        /// - 동의 화면(Consent) 에서 사용자가 특정 권한을 거부
        case insufficientScope

        /// 토큰 scope 는 충분해도, 사용자의 역할(Role)/등급/플랜이 기능 접근을 허용하지 않음
        /// 원인:
        /// - 유료 플랜만 가능한 기능을 무료 플랜이 호출
        /// - admin만 가능한 API를 member가 호출
        case roleDenied

        /// 역할도/스코프도 맞는데, 특정 리소스(자원) 단위로 접근이 금지된 상태
        /// “권한이 없다”기보단 “대상이 잘못됐다/권한 없는 대상이다”
        /// 원인:
        /// - 다른 사용자 데이터에 접근 시도
        /// - 내가 소유하지 않은 데이터 수정 시도
        /// - 민감한 데이터 접근 차단(법적/보안)
        case resourceForbidden
    }

    enum AccountRestrictedReason: Error, Equatable {
        // 휴먼
        case disabled
        // 정지
        case suspended
        // 탈퇴
        case withdrawn
    }
}

// MARK: Presentaion Layer Resolution - User Action
enum AuthResolution: Equatable {
    enum ReauthAction {
        /// 로컬에 저장된 토큰 정보가 유효한 상태에서 다시 로그인이 필요한 경우
        case normal

        /// 강제 로그아웃
        /// - 리포트 로그아웃 등
        /// - 서버에서 토큰 강제 만료
        case forceLogout

        /// 비밀번호 변경 등 보안상 다시 로그인이 필요한 경우
        case securityReauth
    }

    enum ResolutionMessage: Equatable {
        case sessionExpired
        case sessionInvalid
        case sessionRevoked
        case credentialChanged
        case misconfiguredClient
    }

    enum SupportMessage: Equatable {
        case clientMisconfigured
        case accountSuspended
        case accountDisabled
        case accountDeleted
    }

    case reauth(action: ReauthAction, message: ResolutionMessage)
    case showAccessDenied(message: AuthDomainError.PermissionDeniedReason)
    case contactSupport(message: SupportMessage)
}

extension AuthDomainError {
    /// 도메인 의미는 유지하면서, 앱 레벨에서 필요한 사용자 액션으로 매핑
    var resolution: AuthResolution {
        switch self {
        case .authRequired(let reason):
            return resolve(reason)
        case .permissionDenied(let reason):
            return resolve(reason)
        case .accountRestricted(let reason):
            return resolve(reason)
        }
    }

    /// 인증 관련 Resolution
    private func resolve(_ reason: AuthRequiredReason) -> AuthResolution {
        switch reason {
        case .accessTokenExpired, .refreshTokenExpired:
            // 만료
            return .reauth(action: .normal, message: .sessionExpired)
        case .accessTokenInvalid,
             .refreshTokenInvalid,
             .refreshTokenMissing:
            // 무효/불일치/손상
            return .reauth(action: .forceLogout, message: .sessionInvalid)
        case .accessTokenRevoked, .refreshTokenRevoked:
            // 폐기 - 강제 로그아웃
            return .reauth(action: .forceLogout, message: .sessionRevoked)
        case .credentialChanged:
            // 비번 변경 등
            return .reauth(action: .securityReauth, message: .credentialChanged)
        case .clientMisconfigured:
            // 앱 환경 문제
            return .contactSupport(message: .clientMisconfigured)
        }
    }

    /// 권한 관련 Resolution
    private func resolve(_ reason: PermissionDeniedReason) -> AuthResolution {
        return .showAccessDenied(message: reason)
    }


    /// 계정 관련 Resolution
    private func resolve(_ reason: AccountRestrictedReason) -> AuthResolution {
        switch reason {
        case .suspended:
            return .contactSupport(message: .accountSuspended)
        case .withdrawn:
            return .contactSupport(message: .accountDeleted)
        case .disabled:
            return .contactSupport(message: .accountDisabled)
        }
    }
}
