//
//  ErrorOrigin.swift
//  Somniary
//
//  Created by 송태환 on 10/22/25.
//

import Foundation

struct ErrorOrigin: Equatable {
    let file: String
    let function: String
    let line: Int

    var fileName: String {
        (file as NSString).lastPathComponent
    }

    var description: String {
        "Origin: \(fileName):\(line) Caller: \(function)"
    }
}
