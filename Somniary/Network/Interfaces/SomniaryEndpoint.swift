//
//  SomniaryEndpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

protocol SomniaryEndpoint: Endpoint {}

extension SomniaryEndpoint {

    var baseURL: URL {
        return URL(string: "https://api.somniary.io")!
    }
}
