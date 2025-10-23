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
            self.typeName = "None"
            self.message = ""
            self.code = nil
            return
        }

        self.typeName = String(describing: type(of: error))
        self.message = error.localizedDescription

        // NetworkError 같은 특정 타입 처리
        if let networkError = error as? NetworkError {
            switch networkError {
            case .httpError(let code), .serverError(let code):
                self.code = String(code)
            default:
                self.code = nil
            }
        } else {
            self.code = (error as NSError).code != 0 ? String((error as NSError).code) : nil
        }
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
