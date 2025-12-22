//
//  AuthRepository.swift
//  Somniary
//
//  Created by 송태환 on 9/24/25.
//

import Foundation

protocol RemoteAuthRepository {
    func requestOtpCode(email: String, createUser: Bool, idempotencyKey: String?) async throws -> VoidResponse
    func verify(email: String, otpCode: String, idempotencyKey: String?) async throws -> TokenEntity
    func verify(credential: AppleCredential, idempotencyKey: String?) async throws -> TokenEntity
    func logout() async throws -> Void
}
