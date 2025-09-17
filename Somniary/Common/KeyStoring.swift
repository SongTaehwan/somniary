//
//  KeyStoring.swift
//  Somniary
//
//  Created by 송태환 on 9/12/25.
//

import Foundation

/// 키 저장소 프로토콜
protocol KeyStoring<ValueKey> {
    associatedtype ValueKey

    /// 명령적인 성격. 실패 시 사용자 액션 요구
    func save<T: Codable>(_ value: T, for key: ValueKey) throws
    /// 질의적인 성격. 다양한 처리 방식 요구
    func retrieve<T: Decodable>(for key: ValueKey) -> T?
    func clear(keys: [ValueKey])
}

// MARK: UserDefaults 기반 기본 구현
extension KeyStoring where ValueKey: RawRepresentable, ValueKey.RawValue == String, ValueKey: CaseIterable, ValueKey.AllCases == [ValueKey] {

    func save<T: Codable>(_ value: T, for key: ValueKey) throws {
        let data = try JSONEncoder().encode(value)
        UserDefaults.standard.set(data, forKey: key.rawValue)
    }

    func retrieve<T: Decodable>(for key: ValueKey) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key.rawValue) else {
            return nil
        }

        // TODO: 디코딩 실패 에러 핸들링
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
