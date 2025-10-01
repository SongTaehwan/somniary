//
//  SomniaryNetworking.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

protocol SomniaryNetworking<Target> {
    associatedtype Target

    func request<T: Decodable>(_ endpoint: Target, type: T.Type) async throws -> T
}
