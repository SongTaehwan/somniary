//
//  TokenReposable.swift
//  Somniary
//
//  Created by 송태환 on 10/14/25.
//

import Foundation

protocol TokenReposable<Token> {
    associatedtype Token

    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func updateToken(_ token: Token) throws
    func clear()
}
