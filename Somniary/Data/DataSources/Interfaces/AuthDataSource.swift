//
//  AuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 11/4/25.
//

import Foundation

protocol AuthDataSource {
    
    func requestOtpCode(email: String, createUser: Bool, idempotencyKey: String?) async throws -> NetAuth.VoidResponse
    func verify(email: String, otpCode: String, idempotencyKey: String?) async throws -> NetAuth.Verify.Response
    func verify(credential: AppleCredential, idempotencyKey: String?) async throws -> NetAuth.Verify.Response
}
