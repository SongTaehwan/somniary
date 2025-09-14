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

// MARK: associatedtype 이 enum 타입인 경우를 가정
extension KeyStoring where ValueKey: RawRepresentable, ValueKey.RawValue == String, ValueKey: CaseIterable, ValueKey.AllCases == [ValueKey] {

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

    /// 명시적 타입 지정을 통한 구조체 불러오기
    func retrieve<T: Decodable>(type: T.Type, for key: ValueKey) -> T? {
        return retrieve(for: key)
    }

    /// 복수 키 삭제
    func clear(keys: [ValueKey] = ValueKey.allCases) {
        keys.forEach({ UserDefaults.standard.removeObject(forKey: $0.rawValue) })
    }

    /// 단일 키 삭제
    func clear(_ key: ValueKey) {
        clear(keys: [key])
    }
}
