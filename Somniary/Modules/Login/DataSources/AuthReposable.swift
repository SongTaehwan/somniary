//
//  AuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 9/24/25.
//

import Foundation

protocol AuthReposable {

    func requestOtpCode(email: String, createUser: Bool, idempotencyKey: String?) async throws -> VoidResponse
    func verify(email: String, otpCode: String) async throws -> TokenEntity
}
