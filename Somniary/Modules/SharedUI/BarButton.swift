//
//  BarButton.swift
//  Somniary
//
//  Created by 송태환 on 9/29/25.
//

import SwiftUI

struct BarButton: View {

    private let text: String
    private let action: () -> Void

    init(_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Color.blue)
                .cornerRadius(12)
                .lineLimit(1)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    BarButton("애플 계정으로 로그인") {
        print("tapped")
    }
}
