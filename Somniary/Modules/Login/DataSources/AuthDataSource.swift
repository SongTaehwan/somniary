//
//  AuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 9/24/25.
//

import Foundation

protocol AuthDataSource {
    func login(email: String, code: String, idempotencyKey: String?) async throws -> Token
    func signup(email: String, code: String, idempotencyKey: String?) async throws -> Token
}
