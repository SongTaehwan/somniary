//
//  ButtonSize+Environment.swift
//  Somniary
//
//  Created by 송태환 on 10/5/25.
//

import SwiftUI

struct ButtonSizeKey: EnvironmentKey {
    static let defaultValue: ButtonSize? = nil
}

extension EnvironmentValues {
    var buttonSize: ButtonSize? {
        get { self[ButtonSizeKey.self] }
        set { self[ButtonSizeKey.self] = newValue }
    }
}
