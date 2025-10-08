//
//  SomniaryButtonStyleModifier.swift
//  Somniary
//
//  Created by 송태환 on 10/5/25.
//

import SwiftUI

extension View {

    func somniaryButtonStyle(_ style: SomniaryButtonStyle) -> some View {
        self.buttonStyle(style)
    }

    func somniaryTextButtonStyle(_ style: SomniaryTextButtonStyle) -> some View {
        self.buttonStyle(style)
    }
}
