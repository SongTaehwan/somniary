//
//  Token+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 10/4/25.
//

import Foundation

extension Token: Equatable {
    static func == (lhs: Token, rhs: Token) -> Bool {
        lhs.accessToken == rhs.accessToken && lhs.refreshToken == rhs.refreshToken
    }
}
