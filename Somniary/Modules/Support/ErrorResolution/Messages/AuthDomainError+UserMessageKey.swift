//
//  AuthDomainError+UserMessageKey.swift
//  Somniary
//
//  Created by 송태환 on 1/5/26.
//

import Foundation

extension AuthDomainError: UserMessageKeyProviding {
    var userMessageKey: String {
        switch self {
        case .authRequired(let reason):
            return reason.userMessageKey
        case .permissionDenied(let reason):
            return reason.userMessageKey
        case .accountRestricted(let reason):
            return reason.userMessageKey
        }
    }
}

extension AuthDomainError.AuthRequiredReason: UserMessageKeyProviding {
    var userMessageKey: String {
        switch self {
        // 만료
        case .accessTokenExpired, .refreshTokenExpired:
            return "auth.session.expired"

        // 무효/손상/불일치
        case .accessTokenInvalid,
             .refreshTokenInvalid,
             .refreshTokenMissing,
             .unknownUnauthorized:
            return "auth.session.invalid"

        // 리보크/강제 만료
        case .accessTokenRevoked, .refreshTokenRevoked:
            return "auth.session.revoked"

        // 계정 보안 변경
        case .credentialChanged:
            return "auth.credential.changed"

        // 클라이언트 환경 문제
        case .clientMisconfigured:
            return "auth.client.misconfigured"
        }
    }
}

extension AuthDomainError.PermissionDeniedReason: UserMessageKeyProviding {
    var userMessageKey: String {
        switch self {
        case .insufficientScope:
            return "auth.permission.insufficient_scope"
        case .roleDenied:
            return "auth.permission.role_denied"
        case .resourceForbidden:
            return "auth.permission.resource_forbidden"
        case .unknownForbidden:
            return "auth.permission.denied"
        }
    }
}

extension AuthDomainError.AccountRestrictedReason: UserMessageKeyProviding {
    var userMessageKey: String {
        switch self {
        case .disabled:
            return "auth.account.disabled"
        case .suspended:
            return "auth.account.suspended"
        case .withdrawn:
            return "auth.account.withdrawn"
        }
    }
}
