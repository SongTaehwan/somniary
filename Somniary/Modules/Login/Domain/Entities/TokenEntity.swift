//
//  TokenEntity.swift
//  Somniary
//
//  Created by 송태환 on 9/12/25.
//

import Foundation

struct TokenEntity: Codable {
    let accessToken: String
    let refreshToken: String
}

extension TokenEntity: Equatable {
    static func == (lhs: TokenEntity, rhs: TokenEntity) -> Bool {
        lhs.accessToken == rhs.accessToken && lhs.refreshToken == rhs.refreshToken
    }
}
