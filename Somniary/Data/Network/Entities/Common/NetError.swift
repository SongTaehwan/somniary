//
//  NetError.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//

import Foundation

struct NetError: Decodable {
    let code: NetErrorCode
    let details: String?
    let hint: String?
    let message: String
}
