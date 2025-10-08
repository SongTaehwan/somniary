//
//  TypographModifier.swift
//  Somniary
//
//  Created by 송태환 on 10/5/25.
//

import SwiftUI

struct TypographyModifier: ViewModifier {

    let typography: Typography

    func body(content: Content) -> some View {
        content
            .font(typography.font)
            .foregroundStyle(typography.foregroundColor)
            .lineLimit(typography.lineLimit)
    }
}

extension Text {
    /// Label에 typography 스타일 적용
    func typography(_ typography: Typography) -> some View {
        return self.modifier(TypographyModifier(typography: typography))
    }
}

extension View {
    /// 버튼 typography 를 Environment 로 설정
    /// SomniaryButtonStyle 에서 값을 읽어서 적용
    func typography(_ typography: Typography) -> some View {
        self.transformEnvironment(\.typography) { currentValue in
            currentValue = typography
        }
    }
}
