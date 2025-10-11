//
//  Token.swift
//  Somniary
//
//  Created by 송태환 on 9/24/25.
//

import Foundation

struct Token: Codable {
    let accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
