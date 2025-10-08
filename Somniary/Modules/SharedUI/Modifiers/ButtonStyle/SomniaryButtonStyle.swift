//
//  SomniaryButtonStyle.swift
//  Somniary
//
//  Created by 송태환 on 10/5/25.
//

import SwiftUI

struct SomniaryButtonStyle: SomniaryButtonStyling {

    @Environment(\.typography) var typographyOverride: Typography?
    @Environment(\.buttonSize) var buttonSizeOverride: ButtonSize?
    @Environment(\.isEnabled) var isEnabled: Bool

    var backgroundColor: Color = .clear
    var disabledColor: Color = Color(.systemGray4)
    var cornerRadius: CGFloat = 12
    var padding: EdgeInsets = EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
    var pressedOpacity: Double = 0.7

    var defaultTypography: Typography = .body
    var defaultButtonSize: ButtonSize = .fullWidth

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
            .padding(padding)
            .background(isEnabled ? backgroundColor : disabledColor)
            .cornerRadius(cornerRadius)
            .opacity(configuration.isPressed ? self.pressedOpacity : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Style Presets
extension SomniaryButtonStyle {
    /// Primary 버튼 (강조, full width)
    static let primary = SomniaryButtonStyle(
        backgroundColor: .primary
    )

    /// Secondary 버튼 (보조, full width)
    static let secondary = SomniaryButtonStyle(
        backgroundColor: .secondary
    )

    /// Destructive 버튼 (경고, full width)
    static let destructive = SomniaryButtonStyle(
        backgroundColor: Color(.systemRed)
    )
}

#Preview {
    VStack {
        Button("Primary") { }
        .somniaryButtonStyle(.primary)

        Button("Primary+disabled") { }
        .somniaryButtonStyle(.primary)
        .disabled(true)

        Button("Secondary") { }
        .somniaryButtonStyle(.secondary)

        Button("Secondary+disabled") { }
        .somniaryButtonStyle(.secondary)
        .disabled(true)

        Button("destructive") { }
        .somniaryButtonStyle(.destructive)

        Button("destructive+disabled") { }
        .somniaryButtonStyle(.destructive)
        .disabled(true)
    }
    .padding()
}
