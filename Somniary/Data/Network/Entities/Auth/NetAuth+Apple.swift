//
//  NetAuth+Apple.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

extension NetAuth {
    enum Apple {
        struct Request: Encodable {
            let idToken: String
            let provider: String = "apple"
            let nonce: String
        }

        typealias Response = NetAuth.Email.Response
    }
}
