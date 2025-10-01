//
//  SomniaryNetworking.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation
import Combine

protocol SomniaryNetworking<Target> {
    associatedtype Target

    func request<T: Decodable>(_ endpoint: Target, type: T.Type) async throws -> T
}

extension SomniaryNetworking {
    func publisher<T: Decodable>(_ endpoint: Target, type: T.Type) -> AnyPublisher<T, Error> {
        return Future { promise in
            Task {
                do {
                    let result = try await request(endpoint, type: type)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
