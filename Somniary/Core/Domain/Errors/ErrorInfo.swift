//
//  ErrorInfo.swift
//  Somniary
//
//  Created by 송태환 on 10/15/25.
//

import Foundation

/// 에러 정보의 구조화된 표현 형식
/// 로깅, 모니터링, 분석, 알림 등 다양한 용도로 사용
// TODO: 외부 모니터링 시스템 연동
struct ErrorInfo: Equatable {
    /// 에러가 발생한 도메인 (auth, diary, profile 등)
    let domain: String

    /// 에러 유형
    let errorType: String

    /// 사용자 메시지
    let userMessage: String

    /// 개발자 메시지 (로깅/디버깅용)
    let message: String?

    /// 심각도
    let severity: ErrorSeverity

    /// 발생 시각
    let timestamp: Date

    /// 도메인별 상세 정보
    var metadata: [String: String?]
}
