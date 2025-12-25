//
//  ApplicationError.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//

import Foundation

/// 유스케이스 실행 과정에서 발생하는 비도메인 실패를 DependencyFailure(의존성) 와 InternalFailure(로직) 로 분류해 표현한 에러
enum ApplicationError: Error, Equatable {
    case internalFailure(InternalFailure)
    case dependencyFailure(DependencyFailure)

    /// 미정의 오류
    case uncategorized(String?)
}
