//
//  DependencyFailure.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//


import Foundation

enum DependencyFailure: Equatable {
    enum Dependency: Equatable {
        case database
        case cache
        case searc
        case externalAPI
    }

    enum Operation: Equatable {
        case read
        case write
        case transaction
    }

    enum Certainty: Equatable {
        case definitelyFailed
        case outcomeUnknown
    }

    case unavailable(
      dependency: Dependency,
      operation: Operation,
      retriable: Bool,
      certainty: Certainty,
      causeCode: String? = nil
    )
}