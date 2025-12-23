//
//  ApplicationError.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//

import Foundation

enum ApplicationError: Error, Equatable {
    case dependencyFailure(DependencyFailure)
    case cancelled
    case unexpected
}


