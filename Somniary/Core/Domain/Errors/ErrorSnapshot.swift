//
//  ErrorSnapshot.swift
//  Somniary
//
//  Created by 송태환 on 10/15/25.
//

import Foundation

struct ErrorSnapshot: Equatable {
    let typeName: String
    let message: String
    let code: String?

    init(from error: Error?) {
        guard let error = error else {
            self.typeName = "Unknown"
            self.message = "Unknown"
            self.code = nil
            return
        }

        self.typeName = String(describing: type(of: error))
        self.message = error.localizedDescription
        self.code = (error as NSError).code != 0 ? String((error as NSError).code) : nil
    }

    init(typeName: String, message: String, code: String? = nil) {
        self.typeName = typeName
        self.message = message
        self.code = code
    }
}

extension ErrorSnapshot {
    static let unknown = ErrorSnapshot(typeName: "unknown", message: "unknown", code: nil)
}
