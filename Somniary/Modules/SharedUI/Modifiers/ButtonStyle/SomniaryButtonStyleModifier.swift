//
//  SomniaryButtonStyleModifier.swift
//  Somniary
//
//  Created by 송태환 on 10/5/25.
//

import SwiftUI

extension View {

    func somniaryButtonStyle(_ config: SomniaryButtonStyleConfig) -> some View {
        self.buttonStyle(SomniaryButtonStyle(styleConfig: config))
    }
}
