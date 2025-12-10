//
//  Array+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 10/1/25.
//

import Foundation

extension Array {
    var isNotEmpty: Bool {
        !self.isEmpty
    }

    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else {
            return [self]
        }

        return stride(from: 0, to: count, by: size).map { index in
            Array(self[index..<Swift.min(index + size, count)])
        }
    }
}
