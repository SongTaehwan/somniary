//
//  HTTPResponse.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

struct HTTPResponse {
    let url: URL
    let headers: [String: String]
    let status: Int
    let body: Data?
}
