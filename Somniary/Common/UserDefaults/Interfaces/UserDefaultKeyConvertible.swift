//
//  UserDefaultKeyConvertible.swift
//  Somniary
//
//  Created by 송태환 on 11/5/25.
//

import Foundation

// MARK: - Key 프로토콜 추상화
/// UserDefaults 저장소에서 사용할 수 있는 키 타입을 정의하는 프로토콜
protocol UserDefaultKeyConvertible {
    var stringValue: String { get }
}

// String을 직접 키로 사용할 수 있도록 확장
extension String: UserDefaultKeyConvertible {
    var stringValue: String { self }
}

// RawRepresentable enum (String 기반)을 키로 사용할 수 있도록 확장
extension RawRepresentable where RawValue == String, Self: UserDefaultKeyConvertible {
    var stringValue: String { self.rawValue }
}
