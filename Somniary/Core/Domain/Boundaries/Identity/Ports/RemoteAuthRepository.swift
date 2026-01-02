//
//  AuthRepository.swift
//  Somniary
//
//  Created by 송태환 on 9/24/25.
//

import Foundation

protocol RemoteAuthRepository {
    /// 이메일 OTP 인증 요청
    func requestOtpCode(email: String, createUser: Bool, idempotencyKey: String?) async -> Result<Void, PortFailure<IdentityBoundaryError>>

    /// 이메일 인증
    func verify(email: String, otpCode: String, idempotencyKey: String?) async -> Result<TokenEntity, PortFailure<IdentityBoundaryError>>

    /// 애플 인증
    func verify(credential: AppleCredential, idempotencyKey: String?) async -> Result<TokenEntity, PortFailure<IdentityBoundaryError>>

    /// 통합 로그아웃
    func logout() async -> Result<Void, PortFailure<IdentityBoundaryError>>
}
