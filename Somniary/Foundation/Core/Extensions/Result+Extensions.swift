//
//  Result+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

extension Result where Failure == Error {
    // async with error mapper
    static func catching(_ body: () async throws -> Success) async -> Self {
        do {
            return .success(try await body())
        } catch {
            return .failure(error)
        }
    }

    // sync with error mapper
    static func catching(_ body: () throws -> Success) -> Self {
        do {
            return .success(try body())
        } catch {
            return .failure(error)
        }
    }
}

extension Result {
    // async task with error mapper
    static func catching(_ body: () async throws -> Success, mapError: (Error) -> Failure) async -> Self {
        do {
            return .success(try await body())
        } catch {
            return .failure(mapError(error))
        }
    }

    // sync with error mapper
    static func catching(_ body: () throws -> Success, mapError: (Error) -> Failure) -> Self {
        do {
            return .success(try body())
        } catch {
            return .failure(mapError(error))
        }
    }
}
