//
//  TokenReposable.swift
//  Somniary
//
//  Created by 송태환 on 10/14/25.
//

import Foundation

protocol TokenReposable {
    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func updateToken(_ token: TokenEntity) throws
    func clear()
}
