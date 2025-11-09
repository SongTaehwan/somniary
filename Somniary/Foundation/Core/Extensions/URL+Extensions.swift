//
//  URL+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 10/1/25.
//

import Foundation

extension URL {
    func appending(path: String, queryItems: [URLQueryItem]) -> Self {
        let url = self.appending(path: path)

        if queryItems.isEmpty {
            return url
        }

        return url.appending(queryItems: queryItems)
    }
}
