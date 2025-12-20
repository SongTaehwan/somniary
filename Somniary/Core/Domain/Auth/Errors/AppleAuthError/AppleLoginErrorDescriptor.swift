//
//  AppleLoginErrorDescriptor.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//


import Foundation

enum AppleLoginErrorDescriptor: String, ErrorDescriptor {
    case cancelled
    case invalidResponse
    case notHandled
    case failed
    case missingNonce
    case unknown
    case unexpected

    init(from error: Error) {
        let nsError = error as NSError

        if nsError.domain == "com.apple.AuthenticationServices.AuthorizationError" {
            switch nsError.code {
                // ASAuthorizationError.canceled
            case 1001: self = .cancelled
                // ASAuthorizationError.invalidResponse
            case 1002: self = .invalidResponse
                // ASAuthorizationError.notHandled
            case 1003: self = .notHandled
                // ASAuthorizationError.failed
            case 1004: self = .failed
            default: self = .unknown
            }
        } else {
            self = .unknown
        }
    }

    // MARK: Protocols
    var userMessage: String {
        switch self {
        case .cancelled: return "로그인이 취소되었습니다."
        case .invalidResponse: return "잘못된 응답입니다."
        case .notHandled: return "처리할 수 없는 요청입니다."
        case .failed: return "로그인에 실패했습니다."
        case .missingNonce: return "보안 검증 실패. 다시 시도해주세요."
        case .unknown, .unexpected: return "알 수 없는 오류 발생"
        }
    }

    var severity: ErrorSeverity {
        switch self {
        case .cancelled:
            return .warning
        default:
            return .critical
        }
    }

    var domain: DomainType {
        return .auth
    }
}
