//
//  Typography.swift
//  Somniary
//
//  Created by 송태환 on 10/5/25.
//

import SwiftUI

struct Typography {
    
    private(set) var font: Font
    private(set) var foregroundColor: Color
    private(set) var lineLimit: Int?
    private(set) var disabledColor: Color

    init(font: Font, foregroundColor: Color, lineLimit: Int? = nil, disabledColor: Color = .white) {
        self.font = font
        self.foregroundColor = foregroundColor
        self.lineLimit = lineLimit
        self.disabledColor = disabledColor
    }
}

// MARK: 부분 커스텀
extension Typography {

    func foregroundColor(_ color: Color) -> Self {
        var copy = self
        copy.foregroundColor = color
        return copy
    }

    func disabledColor(_ color: Color) -> Self {
        var copy = self
        copy.disabledColor = color
        return copy
    }
}

// MARK: Presets
extension Typography {

    static let title = Typography(
        font: .title2.weight(.semibold),
        foregroundColor: .primary,
    )

    static let headline = Typography(
        font: .headline,
        foregroundColor: .primary,
    )

    static let body = Typography(
        font: .body,
        foregroundColor: .primary,
    )

    static let caption = Typography(
        font: .caption,
        foregroundColor: .primary,
    )

    static let text = Typography(
        font: .body,
        foregroundColor: .accentColor,
        disabledColor: Color(.systemGray)
    )

    static let errorMessage = Typography(
        font: .caption,
        foregroundColor: Color(.systemRed),
    )
}
