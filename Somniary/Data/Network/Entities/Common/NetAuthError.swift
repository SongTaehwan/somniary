//
//  NetAuthError.swift
//  Somniary
//
//  Created by 송태환 on 1/14/26.
//

import Foundation

struct NetAuthError: Decodable {
    let status: Int
    let errorCode: NetAuthErrorCode
    let message: String

    enum CodingKeys: String, CodingKey {
        case status = "code"
        case errorCode = "error_code"
        case message = "msg"
    }

    #if DEBUG
    var deubgMessage: String {
        return """
        ╔══════════════════════════════════════════════════════════════
        ║ 💥 PostgREST Error Details
        ╠══════════════════════════════════════════════════════════════
        ║ 📄 HTTP Status: \(self.status)
        ║ 🎯 Error Code : \(self.errorCode.rawValue)
        ║ 💬 Message    : \(self.message)
        ╠──────────────────────────────────────────────────────────────
        ║ ⏰ Time       : \(Date.now.formatted(date: .numeric, time: .standard))
        ╚══════════════════════════════════════════════════════════════
        """
    }
    #endif
}
