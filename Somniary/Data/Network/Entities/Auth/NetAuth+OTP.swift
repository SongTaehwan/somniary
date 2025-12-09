//
//  NetAuth+OTP.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

extension NetAuth {
    enum OTP {
        struct Request: Encodable {
            let email: String
            let createUser: Bool
        }
    }
}
