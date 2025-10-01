//
//  MaxLengthModifier.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import SwiftUI

struct MaxLengthModifier: ViewModifier {

    @Binding var text: String
    let maxLength: Int

    func body(content: Content) -> some View {
        content
            .onChange(of: text, { oldValue, newValue in
                if newValue.count > maxLength {
                    text = String(newValue.prefix(maxLength))
                }
            })
    }
}

extension View {
    func maxLength(text: Binding<String>, limit: Int) -> some View {
        self.modifier(MaxLengthModifier(text: text, maxLength: limit))
    }
}
