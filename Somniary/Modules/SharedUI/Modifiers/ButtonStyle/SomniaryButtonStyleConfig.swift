//
//  SomniaryButtonStyleConfig.swift
//  Somniary
//
//  Created by 송태환 on 10/9/25.
//

import SwiftUI

struct SomniaryButtonStyleConfig {
    
    var backgroundColor: Color = .clear
    var disabledColor: Color = Color(.systemGray4)
    var cornerRadius: CGFloat = 12
    var padding: EdgeInsets = EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
    var pressedOpacity: Double = 0.7

    var typography: Typography = .body.foregroundColor(.white)
    var buttonSize: ButtonSize = .fullWidth
}

// MARK: - Style Presets
extension SomniaryButtonStyleConfig {
    /// Primary 버튼 (강조, full width)
    static let primary = SomniaryButtonStyleConfig(
        backgroundColor: .primary
    )

    /// Secondary 버튼 (보조, full width)
    static let secondary = SomniaryButtonStyleConfig(
        backgroundColor: .secondary
    )

    /// Destructive 버튼 (경고, full width)
    static let destructive = SomniaryButtonStyleConfig(
        backgroundColor: Color(.systemRed)
    )
}
