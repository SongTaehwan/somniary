//
//  SomniaryTextButtonStyle.swift
//  Somniary
//
//  Created by 송태환 on 10/8/25.
//

import SwiftUI

struct SomniaryTextButtonStyle: SomniaryButtonStyling {

    @Environment(\.typography) var typographyOverride: Typography?
    @Environment(\.buttonSize) var buttonSizeOverride: ButtonSize?
    @Environment(\.isEnabled) var isEnabled: Bool

    var pressedOpacity: Double = 0.7
    var defaultTypography: Typography = .text
    var defaultButtonSize: ButtonSize = .fit

    func makeBody(configuration: Configuration) -> some View {
        let typography = typographyOverride ?? self.defaultTypography
        let buttonSize = buttonSizeOverride ?? self.defaultButtonSize

        configuration.label
            // Label 스타일
            .font(typography.font)
            .foregroundStyle(isEnabled ? typography.foregroundColor : typography.disabledColor)
            .lineLimit(typography.lineLimit)
            // 컨테이너 스타일
            .frame(width: buttonSize.width, height: buttonSize.height)
            .frame(maxWidth: buttonSize.maxWidth)
            .opacity(configuration.isPressed ? self.pressedOpacity : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Style Presets
extension SomniaryTextButtonStyle {
    /// Primary 버튼 (강조)
    static let primary = SomniaryTextButtonStyle()

    /// Secondary 버튼 (보조)
    static let secondary = SomniaryTextButtonStyle()

    /// Destructive 버튼 (경고)
    static let destructive = SomniaryTextButtonStyle(
        defaultTypography: .init(font: .body, foregroundColor: Color(.systemRed), disabledColor: Color(.systemGray))
    )
}

#Preview {
    VStack(spacing: 8) {
        Button("Primary") { }
        .somniaryTextButtonStyle(.primary)

        Button("Primary+disabled") { }
        .somniaryTextButtonStyle(.primary)
        .disabled(true)

        Button("Secondary") { }
        .somniaryTextButtonStyle(.secondary)

        Button("Secondary+disabled") { }
        .somniaryTextButtonStyle(.secondary)
        .disabled(true)

        Button("destructive") { }
        .somniaryTextButtonStyle(.destructive)

        Button("destructive+disabled") { }
        .somniaryTextButtonStyle(.destructive)
        .disabled(true)
    }
    .padding()
}
