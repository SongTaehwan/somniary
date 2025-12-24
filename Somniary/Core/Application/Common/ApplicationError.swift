//
//  ApplicationError.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//

import Foundation

enum ApplicationError: Error, Equatable {
    case internalFailure(InternalFailure)
    case dependencyFailure(DependencyFailure)

    /// 미정의 오류
    case uncategorized(String?)
}
