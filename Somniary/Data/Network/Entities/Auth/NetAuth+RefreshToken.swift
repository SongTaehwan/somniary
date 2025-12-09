//
//  NetAuth+Refresh.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

extension NetAuth {
    enum RefreshToken {
        struct Request: Encodable {
            let refreshToken: String
        }
    }
}
