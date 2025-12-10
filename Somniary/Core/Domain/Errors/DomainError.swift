//
//  DomainError.swift
//  Somniary
//
//  Created by 송태환 on 10/15/25.
//

import Foundation

protocol DomainError: Error, Equatable {
    /// 사용자에게 표시할 메시지
    var userMessage: String { get }

    /// 에러의 심각도
    var severity: ErrorSeverity { get }

    /// 에러 정보를 구조화된 형식으로 변환
    func toErrorInfo() -> ErrorInfo
}
