//
//  ErrorContext.swift
//  Somniary
//
//  Created by 송태환 on 10/15/25.
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

protocol ErrorContext {
    /// 원본 에러
    var errorSnaphot: ErrorSnapshot? { get }

    /// 에러 발생 지점
    var errorOrigin: ErrorOrigin { get }

    /// 발생 시각
    var timestamp: Date { get }

    /// 도메인별 metadata 생성
    var metadata: [String: String] { get }
}

extension ErrorContext {
    var timestamp: Date {
        return Date.now
    }

    var metadata: [String: String] {
        return [:]
    }
}
