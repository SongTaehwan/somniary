//
//  SomniaryTextButtonStyle.swift
//  Somniary
//
//  Created by 송태환 on 10/8/25.
//

import SwiftUI

struct SomniaryTextButtonStyle: SomniaryButtonStyling {

    @Environment(\.isEnabled) var isEnabled: Bool
    @Environment(\.typography) var typographyOverride: Typography?
    @Environment(\.buttonSize) var buttonSizeOverride: ButtonSize?
    @Environment(\.textButtonConfig) var styleConfigOverride: SomniaryTextButtonStyleConfig?

    private let defaultStyleConfig: SomniaryTextButtonStyleConfig

    init(styleConfig: SomniaryTextButtonStyleConfig) {
        self.defaultStyleConfig = styleConfig
    }

    func makeBody(configuration: Configuration) -> some View {
        let activeConfig = styleConfigOverride ?? defaultStyleConfig
        let typography = typographyOverride ?? defaultStyleConfig.typography
        let buttonSize = buttonSizeOverride ?? defaultStyleConfig.buttonSize

        configuration.label
            // Label 스타일
            .font(typography.font)
            .foregroundStyle(isEnabled ? typography.foregroundColor : typography.disabledColor)
            .lineLimit(typography.lineLimit)
            // 컨테이너 스타일
            .frame(width: buttonSize.width, height: buttonSize.height)
            .frame(maxWidth: buttonSize.maxWidth)
            .opacity(configuration.isPressed ? activeConfig.pressedOpacity : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
