//
//  SomniaryTextButtonStyleConfig+Environment.swift
//  Somniary
//
//  Created by 송태환 on 10/9/25.
//

import SwiftUI

struct SomniaryTextButtonConfigKey: EnvironmentKey {
    static let defaultValue: SomniaryTextButtonStyleConfig? = nil
}

extension EnvironmentValues {
    var textButtonConfig: SomniaryTextButtonStyleConfig? {
        get { self[SomniaryTextButtonConfigKey.self] }
        set { self[SomniaryTextButtonConfigKey.self] = newValue }
    }
}
