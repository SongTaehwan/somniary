//
//  NSLock+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

/// Swift 6 부터 nonasync 함수로 지정됨
/// Async 컨텍스트에서 lock/unlock 을 직접 호출하면 안됌(락을 잡은 채 await suspend 될 수 없다는 추론 불가)
/// 동기 컨텍스트를 만들어 Locking 하기 위한 유틸리티
extension NSLock {
    @discardableResult
    func withLock<T>(_ body: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try body()
    }
}
