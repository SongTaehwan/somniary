//
//  Typography+Environment.swift
//  Somniary
//
//  Created by 송태환 on 10/5/25.
//

import SwiftUI

struct TypographyKey: EnvironmentKey {
    static let defaultValue: Typography? = nil
}

extension EnvironmentValues {
    var typography: Typography? {
        get { self[TypographyKey.self] }
        set { self[TypographyKey.self] = newValue }
    }
}
