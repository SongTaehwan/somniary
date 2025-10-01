//
//  NetDiary+Create.swift
//  Somniary
//
//  Created by 송태환 on 10/1/25.
//

import Foundation

/// 생성
extension NetDiary {

    enum Create {
        struct Request: Encodable {
            let title: String
            let content: String
        }
    }
}
