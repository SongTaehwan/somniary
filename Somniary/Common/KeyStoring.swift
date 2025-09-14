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

    func save<T: Codable>(_ value: T, for key: ValueKey)
    func retrieve<T: Decodable>(for key: ValueKey) -> T?
    func clear(keys: [ValueKey])
}

extension KeyStoring where ValueKey: RawRepresentable, ValueKey.RawValue == String {

    func save<T: Codable>(_ value: T, for key: ValueKey) {
        let data = try? JSONEncoder().encode(value)
        UserDefaults.standard.set(data, forKey: key.rawValue)
    }

    func retrieve<T: Decodable>(for key: ValueKey) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key.rawValue) else {
            return nil
        }

        return try? JSONDecoder().decode(T.self, from: data)
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
