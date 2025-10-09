//
//  SomniaryButtonStyleConfig+Environment.swift
//  Somniary
//
//  Created by 송태환 on 10/9/25.
//

import SwiftUI

struct SomniaryButtonStyleConfigKey: EnvironmentKey {
    static let defaultValue: SomniaryButtonStyleConfig? = nil
}

extension EnvironmentValues {
    var buttonStyleConfig: SomniaryButtonStyleConfig? {
        get { self[SomniaryButtonStyleConfigKey.self] }
        set { self[SomniaryButtonStyleConfigKey.self] = newValue }
    }
}

