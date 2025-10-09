//
//  SomniaryTextButtonStyleConfig.swift
//  Somniary
//
//  Created by 송태환 on 10/9/25.
//

import SwiftUI

struct SomniaryTextButtonStyleConfig {
    
    var typography: Typography = .text
    var buttonSize: ButtonSize = .fit
    var pressedOpacity = 0.7
}

// MARK: - Style Presets
extension SomniaryTextButtonStyleConfig {
    /// Primary 버튼 (강조)
    static let primary = SomniaryTextButtonStyleConfig()

    /// Secondary 버튼 (보조)
    static let secondary = SomniaryTextButtonStyleConfig()

    /// Destructive 버튼 (경고)
    static let destructive = SomniaryTextButtonStyleConfig(
        typography: .init(font: .body, foregroundColor: Color(.systemRed), disabledColor: Color(.systemGray))
    )
}
