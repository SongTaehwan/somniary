//
//  UnexpectedFailure.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//

import Foundation

enum UnexpectedFailure<DomainError: Error & Equatable>: Error, Equatable {
    /// 도메인 에러인데 이 유스케이스 계약 밖
    /// "지원하지 않는 상태/정책" 등으로 사용자에게 노출
    case domain(DomainError)
    /// 도메인 불변식 위반 케이스
    /// 주로 앱 코드 수정으로 해결할 수 없는 케이스
    /// 예) 서버 응답 오류, 데이터 정합성 오류
    /// "처리할 수 없습니다" 등으로 사용자에게 노출
    case invariantViolated(reason: String)
}
