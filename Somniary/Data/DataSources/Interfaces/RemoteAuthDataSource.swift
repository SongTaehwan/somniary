//
//  AuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 11/4/25.
//

import Foundation

protocol RemoteAuthDataSource {
    /// 이메일 로그인 인증 코드 요청
    @discardableResult
    func requestOtpCode(payload: NetAuth.OTP.Request, idempotencyKey: String?) async throws -> NetCommon.Void

    /// 이메일 로그인 인증 코드 확인
    func verify(payload: NetAuth.Email.Request, idempotencyKey: String?) async throws -> NetAuth.Email.Response

    /// 애플 로그인 인증
    func verify(payload: NetAuth.Apple.Request, idempotencyKey: String?) async throws -> NetAuth.Apple.Response

    // TODO: Add Google Auth
}
