//
//  NetDiary+Get.swift
//  Somniary
//
//  Created by 송태환 on 10/1/25.
//

import Foundation

/// 단건 조회
extension NetDiary {

    enum Get {
        struct Response: Decodable {
            let title: String
            let content: String
        }
    }
}
