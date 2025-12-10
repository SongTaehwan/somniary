//
//  LocalStorage.swift
//  Somniary
//
//  Created by 송태환 on 9/12/25.
//

import Foundation

struct LocalStorage<Key>: KeyStoring where Key: RawRepresentable, Key.RawValue == String, Key: CaseIterable, Key.AllCases == [Key] {
    typealias ValueKey = Key
}
