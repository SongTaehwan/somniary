//
//  SomniaryButtonStyle.swift
//  Somniary
//
//  Created by 송태환 on 10/5/25.
//

import SwiftUI

struct SomniaryButtonStyle: SomniaryButtonStyling {

    @Environment(\.isEnabled) var isEnabled: Bool
    @Environment(\.typography) var typographyOverride: Typography?
    @Environment(\.buttonSize) var buttonSizeOverride: ButtonSize?
    @Environment(\.buttonStyleConfig) var styleConfigOverride: SomniaryButtonStyleConfig?

    private let defaultStyleConfig: SomniaryButtonStyleConfig

    init(styleConfig: SomniaryButtonStyleConfig) {
        self.defaultStyleConfig = styleConfig
    }

    func makeBody(configuration: Configuration) -> some View {
        let activeConfig = styleConfigOverride ?? self.defaultStyleConfig
        let typography = typographyOverride ?? self.defaultStyleConfig.typography
        let buttonSize = buttonSizeOverride ?? self.defaultStyleConfig.buttonSize

        configuration.label
            // Label 스타일
            .font(typography.font)
            .foregroundStyle(isEnabled ? typography.foregroundColor : typography.disabledColor)
            .lineLimit(typography.lineLimit)
            // 컨테이너 스타일
            .frame(width: buttonSize.width, height: buttonSize.height)
            .frame(maxWidth: buttonSize.maxWidth)
            .padding(activeConfig.padding)
            .background(isEnabled ? activeConfig.backgroundColor : activeConfig.disabledColor)
            .cornerRadius(activeConfig.cornerRadius)
            .opacity(configuration.isPressed ? activeConfig.pressedOpacity : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
