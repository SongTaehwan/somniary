//
//  Data+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 1/11/26.
//

import Foundation

#if DEBUG
extension Data {
    var debugMessage: String {
        if let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
           let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
           return String(data: prettyPrintedData, encoding: .utf8) ?? "non-utf8 body, bytes=\(self.count)"
        }

        return "Empty JSON"
    }
}
#endif
