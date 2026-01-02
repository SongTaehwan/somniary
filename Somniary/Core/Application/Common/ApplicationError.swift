//
//  ApplicationError.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//

import Foundation

/// 유스케이스 실행 과정에서 발생하는 비도메인 실패를 DependencyFailure(의존성) 와 InternalFailure(로직) 로 분류해 표현한 에러
enum ApplicationError: Error, Equatable {
    /// 런타임, 로직 오류 / 도메인 불변식 위반
    case internalFailure(InternalFailure)

    /// 응답 계약 위반 (외부 의존성 응답 계약 위반)
    /// - 비즈니스 의미가 아니라 시스템 통합 실패로 간주
    /// - 응답 계약은 “서버가 준 JSON이 깨졌다 / 단일이 아니었다 / 스키마가 바뀌었다” 같은 통신/통합의 실패를 의미
    case dependencyFailure(DependencyFailure)

    /// 미정의 오류
    case uncategorized(String?)
}
