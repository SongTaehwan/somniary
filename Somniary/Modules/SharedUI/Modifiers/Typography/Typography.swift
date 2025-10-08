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
    let lineLimit: Int
    let disabledColor: Color

    init(font: Font, foregroundColor: Color, lineLimit: Int = 1, disabledColor: Color = .white) {
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
        lineLimit: 1
    )

    static let headline = Typography(
        font: .headline,
        foregroundColor: .white,
        lineLimit: 1
    )

    static let body = Typography(
        font: .body,
        foregroundColor: .white,
        lineLimit: 1
    )

    static let caption = Typography(
        font: .caption,
        foregroundColor: .white,
        lineLimit: 1
    )

    static let text = Typography(
        font: .body,
        foregroundColor: .primary,
        lineLimit: 1,
        disabledColor: Color(.systemGray)
    )
}
