//
//  ErrorContext.swift
//  Somniary
//
//  Created by 송태환 on 10/15/25.
//

import Foundation

protocol ErrorContext {
    /// 원본 에러
    var errorSnapshot: ErrorSnapshot? { get }

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
