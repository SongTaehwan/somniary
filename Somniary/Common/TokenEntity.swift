//
//  TokenEntity.swift
//  Somniary
//
//  Created by 송태환 on 9/12/25.
//

import Foundation

struct TokenEntity: Codable {
    var accessToken: String
    var refreshToken: String
}
