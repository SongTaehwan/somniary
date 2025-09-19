//
//  Result+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

extension Result where Failure == Error {
    static func catching(_ body: () async throws -> Success) async -> Self {
        do {
            return .success(try await body())
        } catch {
            return .failure(error)
        }
    }
}

extension Result {
    static func catching(_ body: () async throws -> Success, mapError: (Error) -> Failure) async -> Self {
        do {
            return .success(try await body())
        } catch {
            return .failure(mapError(error))
        }
    }
}
