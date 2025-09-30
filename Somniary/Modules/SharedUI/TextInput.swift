//
//  TextInput.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import SwiftUI

struct TextInput: View {

    @Binding var text: String
    let placeholder: String

    init(_ placeholder: String = "", text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        TextField(placeholder, text: $text)
            .padding(20)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray, lineWidth: 1)
                    .cornerRadius(16)
            )
    }
}

#Preview {
    TextInput("Text", text: .constant("text"))
}
