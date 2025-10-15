//
//  NetAuth+Post.swift
//  Somniary
//
//  Created by 송태환 on 10/1/25.
//

import Foundation

extension NetAuth {

    enum Verify {
        struct Response: Decodable {
            let accessToken: String
            let refreshToken: String
            let tokenType: String
            let expiredIn: Int
            let expiresAt: Int

            enum CodingKeys: String, CodingKey {
                case accessToken = "access_token"
                case refreshToken = "refresh_token"
                case tokenType = "token_type"
                case expiredIn = "expires_in"
                case expiresAt = "expires_at"
            }
        }
    }
}
