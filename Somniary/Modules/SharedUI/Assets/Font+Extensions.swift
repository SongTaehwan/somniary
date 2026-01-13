//
//  Font+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 1/13/26.
//

import SwiftUI

extension SwiftUI.Font {
    static let heading1 = SwiftUI.Font.custom(FontFamily.PretendardVariable.regular, size: 24).bold()
    static let title1 = SwiftUI.Font.custom(FontFamily.PretendardVariable.regular, size: 16).bold()
    static let title2 = SwiftUI.Font.custom(FontFamily.PretendardVariable.regular, size: 16).weight(.medium)
    static let body1 = SwiftUI.Font.custom(FontFamily.PretendardVariable.regular, size: 14).bold()
    static let body2 = SwiftUI.Font.custom(FontFamily.PretendardVariable.regular, size: 14).weight(.medium)
    static let caption1 = SwiftUI.Font.custom(FontFamily.PretendardVariable.regular, size: 12).weight(.regular)
    static let navi = SwiftUI.Font.custom(FontFamily.PretendardVariable.regular, size: 10).weight(.regular)
}
