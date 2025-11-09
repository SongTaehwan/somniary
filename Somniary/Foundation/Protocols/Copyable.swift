//
//  Copyable.swift
//  Somniary
//
//  Created by 송태환 on 10/11/25.
//

import Foundation

protocol Copyable {}

extension Copyable {
    /// KeyPath를 사용한 함수형 불변 업데이트
    func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}
