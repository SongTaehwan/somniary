//
//  AppleLoginError.swift
//  Somniary
//
//  Created by 송태환 on 10/11/25.
//

import Foundation

enum AppleLoginError: Equatable, LocalizedError {
    case cancelled
    case invalidResponse
    case notHandled
    case failed
    case missingNonce
    case unknown(String)

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
            default: self = .unknown(error.localizedDescription)
            }
        } else {
            self = .unknown(error.localizedDescription)
        }
    }

    var errorDescription: String {
        switch self {
        case .cancelled: return "로그인이 취소되었습니다."
        case .invalidResponse: return "잘못된 응답입니다."
        case .notHandled: return "처리할 수 없는 요청입니다."
        case .failed: return "로그인에 실패했습니다."
        case .missingNonce: return "보안 검증 실패. 다시 시도해주세요."
        case .unknown(let message): return message
        }
    }
}
