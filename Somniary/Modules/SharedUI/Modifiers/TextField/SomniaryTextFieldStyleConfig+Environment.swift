//
//  SomniaryTextFieldStyleConfig+Environment.swift
//  Somniary
//
//  Created by 송태환 on 10/9/25.
//

import SwiftUI

private struct SomniaryTextFieldStyleConfigKey: EnvironmentKey {
    static let defaultValue: SomniaryTextFieldStyleConfig? = nil
}

extension EnvironmentValues {
    var somniaryTextFieldConfig: SomniaryTextFieldStyleConfig? {
        get { self[SomniaryTextFieldStyleConfigKey.self] }
        set { self[SomniaryTextFieldStyleConfigKey.self] = newValue }
    }
}
