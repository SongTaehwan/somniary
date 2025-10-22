//
//  AppleCredential.swift
//  Somniary
//
//  Created by 송태환 on 10/11/25.
//

import Foundation

/// Apple 로그인 인증 정보 (도메인 타입)
struct AppleCredential: Equatable {
    let identityToken: String
    let userIdentifier: String
    let email: String?
    let nonce: String
}
