//
//  TextInput.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import SwiftUI

struct TextInput: View {
    @FocusState private var isFocued
    @Binding var text: String
    let placeholder: String

    init(_ placeholder: String = "", text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder)
            .font(.title2)
            .foregroundStyle(Asset.Colors.Text.secondary.swiftUIColor)
        )
        .padding(20)
        .font(.title2)
        .foregroundStyle(Asset.Colors.Text.primary.swiftUIColor)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isFocued ? Asset.Colors.primary.swiftUIColor : Asset.Colors.Text.secondary.swiftUIColor, lineWidth: 1)
                .cornerRadius(16)
        )
        .focused($isFocued)
    }
}

#Preview {
    TextInput("Text", text: .constant("text"))
}
