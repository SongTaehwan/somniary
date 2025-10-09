//
//  SomniaryTextButtonStyleModifier.swift
//  Somniary
//
//  Created by 송태환 on 10/9/25.
//

import SwiftUI

extension View {

    func somniaryTextButtonStyle(_ config: SomniaryTextButtonStyleConfig) -> some View {
        self.buttonStyle(SomniaryTextButtonStyle(styleConfig: config))
    }
}
