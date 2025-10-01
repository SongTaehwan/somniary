//
//  AuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 9/24/25.
//

import Foundation

protocol AuthReposable {

    func login(email: String, idempotencyKey: String?) async throws -> VoidResponse
    func signup(email: String, idempotencyKey: String?) async throws -> VoidResponse
    func verify(email: String, otpCode: String, type: String) async throws -> Token
}
