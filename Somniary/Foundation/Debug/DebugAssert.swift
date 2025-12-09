//
//  DebugAssert.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

nonisolated enum DebugAssert {
    /// 조건 검증
    static func assert(
        _ condition: @autoclosure () -> Bool,
        category: DebugCategory,
        severity: DebugSeverity = .error,
        _ message: @autoclosure () -> String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        if !condition() {
            assertionFailure(message(), file: file, line: line)
        }
    }

    /// 무조건 실패 (도달 불가능한 코드)
    static func fail(
        category: DebugCategory,
        severity: DebugSeverity = .critical,
        _ message: @autoclosure () -> String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assertionFailure(message(), file: file, line: line)
    }
}

