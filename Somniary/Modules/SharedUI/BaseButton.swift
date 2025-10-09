//
//  BaseButton.swift
//  Somniary
//
//  Created by 송태환 on 10/5/25.
//

import SwiftUI

// 버튼 스타일은 .buttonStyle modifier 로만 수정한다.

/// 텍스트와 버튼 액션 매개변수
struct BaseButton<Label>: View where Label: View {

    let action: () -> Void
    private let label: () -> Label

    init(action: @escaping @MainActor () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }

    var body: some View {
        Button(action: action) {
            self.label()
        }
    }
}

extension BaseButton where Label == Text {
    init(_ text: any StringProtocol, action: @escaping @MainActor () -> Void) {
        self.action = action
        self.label = { Text(text) }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Primary - 기본 full width
        BaseButton("로그인ㅁ나러미나얾ㄴ이럼ㄴ아ㅣ러ㅏㅁㄴ어리ㅏㅁ넝러ㅏㅣㅁㄴ어ㅏ리ㅓㅁ낭럼너ㅏㅇ리ㅏㅁㄴ어") {
            print("로그인")
        }
        .somniaryButtonStyle(.primary)
        .buttonSize(.fit)
        .typography(.init(font: .body, foregroundColor: .white, lineLimit: 1))

        BaseButton {
            print("회원가입")
        } label: {
            Text("회원가입")
        }
        .somniaryButtonStyle(.destructive)
        .buttonSize(.fit)
        .typography(.body)
    }
    .padding()
}
