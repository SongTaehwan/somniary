//
//  AppleSignInMapper.swift
//  Somniary
//
//  Created by 송태환 on 10/11/25.
//

import Foundation
import AuthenticationServices

/// Apple Sign In SDK 타입 → 도메인 타입 변환
enum AppleSignInMapper {
    /// ASAuthorization을 도메인 타입으로 변환
    static func toCredential(_ authorization: ASAuthorization, expectedNonce: String) -> Result<AppleCredential, AppleLoginError> {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return .failure(.invalidResponse)
        }
        
        guard let identityToken = credential.identityToken
            .flatMap({ String(data: $0, encoding: .utf8) })
        else {
            return .failure(.invalidResponse)
        }

        return .success(AppleCredential(
            identityToken: identityToken,
            userIdentifier: credential.user,
            email: credential.email,
            nonce: expectedNonce
        ))
    }
}
