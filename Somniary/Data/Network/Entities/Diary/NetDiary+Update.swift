//
//  NetDiary+Update.swift
//  Somniary
//
//  Created by 송태환 on 10/1/25.
//

import Foundation

/// 업데이트
extension NetDiary {
    
    enum Update {
        struct Request: Encodable {
            var title: String?
            var content: String?
        }
    }
}
