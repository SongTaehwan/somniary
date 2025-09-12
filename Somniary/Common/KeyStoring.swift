//
//  KeyStoring.swift
//  Somniary
//
//  Created by 송태환 on 9/12/25.
//

import Foundation

/// 키 저장소 프로토콜
/// 기본 구현체는 UserDefaults
protocol KeyStoring {
    associatedtype ValueKey

    func save(_ value: String, for key: ValueKey)
    func retrieve(for key: ValueKey) -> String?
    func clear(keys: [ValueKey])
}

extension KeyStoring where ValueKey: RawRepresentable, ValueKey.RawValue == String {
    func save(_ value: String, for key: ValueKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    func retrieve(for key: ValueKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }

    /// 복수 키 삭제
    func clear(keys: [ValueKey]) {
        keys.forEach({ UserDefaults.standard.removeObject(forKey: $0.rawValue) })
    }

    /// 단일 키 삭제
    func clear(_ key: ValueKey) {
        clear(keys: [key])
    }
}
