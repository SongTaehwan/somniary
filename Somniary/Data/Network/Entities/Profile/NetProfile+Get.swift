//
//  NetProfile+Get.swift
//  Somniary
//
//  Created by 송태환 on 10/1/25.
//

import Foundation

extension NetProfile {

    enum Get {
        struct Response: Decodable {
            let id: String
            let name: String
        }
    }
}
