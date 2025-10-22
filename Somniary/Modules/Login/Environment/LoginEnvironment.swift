//
//  LoginEnvironment.swift
//  Somniary
//
//  Created by 송태환 on 9/24/25.
//

import Foundation

// MARK: Environment
struct LoginEnvironment {
    let auth: AuthReposable
    let reducerEnvironment: LoginReducerEnvironment
    let crypto: CryptoProviding
}
