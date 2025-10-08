//
//  Typography.swift
//  Somniary
//
//  Created by 송태환 on 10/5/25.
//

import SwiftUI

struct Typography {
    
    let font: Font
    let foregroundColor: Color
    let lineLimit: Int?
    let disabledColor: Color

    init(font: Font, foregroundColor: Color, lineLimit: Int? = nil, disabledColor: Color = .white) {
        self.font = font
        self.foregroundColor = foregroundColor
        self.lineLimit = lineLimit
        self.disabledColor = disabledColor
    }
}

// MARK: 프리셋
extension Typography {

    static let title = Typography(
        font: .title2.weight(.semibold),
        foregroundColor: .white,
    )

    static let headline = Typography(
        font: .headline,
        foregroundColor: .white,
    )

    static let body = Typography(
        font: .body,
        foregroundColor: .white,
    )

    static let caption = Typography(
        font: .caption,
        foregroundColor: .white,
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
