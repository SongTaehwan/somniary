//
//  UserDefault+PropertyWrapper.swift
//  Somniary
//
//  Created by 송태환 on 10/2/25.
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

@propertyWrapper
struct UserDefault<Key: UserDefaultKeyConvertible, Value: Codable>  {

    private let container: UserDefaults
    private let key: Key
    private let defaultValue: Value

    init(container: UserDefaults = .standard, key: Key, defaultValue: Value) {
        self.container = container
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: Value {
        get {
            guard let data = container.data(forKey: self.key.stringValue) else {
                return self.defaultValue
            }

            let value = try? JSONDecoder().decode(Value.self, from: data)
            return value ?? self.defaultValue
        }
        set {
            // nil 값 설정 시 저장된 값 제거
            if let optionalValue = newValue as? AnyOptional, optionalValue.isNil {
                self.container.removeObject(forKey: key.stringValue)
                return
            }

            // Optional이 아니거나 nil이 아닌 경우 인코딩하여 저장
            if let data = try? JSONEncoder().encode(newValue) {
                self.container.set(data, forKey: self.key.stringValue)
            }
        }
    }
}

// MARK: nil 허용 생성자 지원
extension UserDefault where Value: ExpressibleByNilLiteral {

    init(container: UserDefaults = .standard, key: Key) {
        self.init(container: container, key: key, defaultValue: nil)
    }
}
