//
//  UserDefault+PropertyWrapper.swift
//  Somniary
//
//  Created by 송태환 on 10/2/25.
//

import Foundation

@propertyWrapper
struct UserDefault<Key, Value: Codable> where Key: RawRepresentable, Key.RawValue == String {

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
            guard let data = container.data(forKey: self.key.rawValue) else {
                return self.defaultValue
            }

            let value = try? JSONDecoder().decode(Value.self, from: data)
            return value ?? self.defaultValue
        }
        set {
            // nil 값 설정 시 저장된 값 제거
            guard let value = newValue as? AnyOptional, value.isNil else {
                self.container.removeObject(forKey: key.rawValue)
                return
            }

            // nil 아닌 Codable xkdlq
            if let data = try? JSONEncoder().encode(newValue) {
                self.container.set(data, forKey: self.key.rawValue)
            }
        }
    }
}

// MARK: nil 허용 생성자 지원
extension UserDefault where Value: ExpressibleByNilLiteral {

    init(key: Key) {
        self.init(key: key, defaultValue: nil)
    }
}
