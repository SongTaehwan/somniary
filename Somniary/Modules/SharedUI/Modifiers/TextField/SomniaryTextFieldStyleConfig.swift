//
//  SomniaryTextFieldStyleConfig.swift
//  Somniary
//
//  Created by 송태환 on 10/9/25.
//

import SwiftUI

struct SomniaryTextFieldStyleConfig {
    
    var backgroundColor: Color
    var disabledBackgroundColor: Color
    var borderColor: Color
    var focusedBorderColor: Color
    var cornerRadius: CGFloat
    var padding: EdgeInsets
    var borderWidth: CGFloat
    var defaultTypography: Typography

    init(
        backgroundColor: Color = Color(.systemGray6),
        disabledBackgroundColor: Color = Color(.systemGray5),
        borderColor: Color = .clear,
        focusedBorderColor: Color = .primary,
        cornerRadius: CGFloat = 12,
        padding: EdgeInsets = EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
        borderWidth: CGFloat = 1,
        defaultTypography: Typography = .body
    ) {
        self.backgroundColor = backgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.borderColor = borderColor
        self.focusedBorderColor = focusedBorderColor
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.borderWidth = borderWidth
        self.defaultTypography = defaultTypography
    }
}

// MARK: - Config Presets
extension SomniaryTextFieldStyleConfig {
    /// 기본 TextField 설정
    static let `default` = SomniaryTextFieldStyleConfig()

    /// 테두리가 있는 TextField 설정
    static let outlined = SomniaryTextFieldStyleConfig(
        backgroundColor: .clear,
        borderColor: Color(.systemGray4),
        focusedBorderColor: .primary
    )

    /// 강조된 TextField 설정 (포커스 시 파란색 테두리)
    static let emphasized = SomniaryTextFieldStyleConfig(
        backgroundColor: .clear,
        borderColor: Color(.systemGray4),
        focusedBorderColor: .blue,
        borderWidth: 2
    )

    /// 에러 상태 TextField 설정 (빨간색 테두리)
    static let error = SomniaryTextFieldStyleConfig(
        backgroundColor: .clear,
        borderColor: Color(.systemRed).opacity(0.3),
        focusedBorderColor: Color(.systemRed),
        borderWidth: 2
    )
}
