//
//  HTTPResponse.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

struct HTTPResponse {
    let endpoint: Endpoint
    let url: URL
    let headers: [String: String]
    let status: Int
    let body: Data?
}

#if DEBUG
extension HTTPResponse {
    func debugPrint(file: String = #file, line: Int = #line) {
        let time = Date.now.formatted(date: .numeric, time: .standard)
        let fileName = (file as NSString).lastPathComponent
        let message = {
            return """
            ╔══════════════════════════════════════════════════════════════
            ║ 🌐 [\(endpoint.method.rawValue)] \(endpoint.path)
            ╠══════════════════════════════════════════════════════════════
            ║ 📍 Location     : \(fileName):\(line)
            ╠══════════════════════════════════════════════════════════════
            ║ 🌐 Status       : \(status)
            ║ 🍿 Content-Type : \(endpoint.headers?["Content-Type"] ?? "Empty")
            ║ 🌐 Bytes        : \(body?.count ?? 0)
            ║ ⏰ Time         : \(time)
            ╚══════════════════════════════════════════════════════════════

            🌐 Headers: \(String(describing: endpoint.headers!.filter({ !$0.value.isEmpty }).keys))
            🌐 Body: \(body?.debugMessage ?? "Empty")
            
            """
        }()

        print(message)
    }
}
#endif
