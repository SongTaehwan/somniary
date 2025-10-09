//
//  ButtonSizeModifier.swift
//  Somniary
//
//  Created by 송태환 on 10/5/25.
//

import SwiftUI

extension View {

    /// 버튼 크기를 Environment로 설정
    /// SomniaryButtonStyle 에서 값을 읽어서 적용
    func buttonSize(_ size: ButtonSize) -> some View {
        self.transformEnvironment(\.buttonSize) { currentValue in
            currentValue = size
        }
    }
}
