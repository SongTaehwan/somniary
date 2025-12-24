//
//  NetProfile+Update.swift
//  Somniary
//
//  Created by 송태환 on 10/1/25.
//

import Foundation

/// 업데이트
extension NetProfile {

    enum Update {
        struct Request: Encodable {
            let name: String?
            let email: String?
        }
    }
}
