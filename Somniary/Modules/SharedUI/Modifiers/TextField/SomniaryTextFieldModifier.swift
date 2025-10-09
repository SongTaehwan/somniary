//
//  SomniaryTextFieldStyle.swift
//  Somniary
//
//  Created by 송태환 on 10/9/25.
//

import SwiftUI

/// 포커스 상태를 감지하고 TextField 스타일을 적용하는 Modifier
struct FocusableTextFieldModifier: ViewModifier {
    
    @Environment(\.isEnabled) var isEnabled: Bool
    @Environment(\.typography) var typographyOverride: Typography?
    @Environment(\.somniaryTextFieldConfig) var config: SomniaryTextFieldStyleConfig?
    
    @FocusState private var internalFocus: Bool
    
    private let defaultConfig: SomniaryTextFieldStyleConfig
    private let externalFocus: FocusState<Bool>.Binding?

    private var isFocused: Bool {
        externalFocus?.wrappedValue ?? internalFocus
    }

    init(config: SomniaryTextFieldStyleConfig, focused: FocusState<Bool>.Binding? = nil) {
        self.defaultConfig = config
        self.externalFocus = focused
    }

    func body(content: Content) -> some View {
        let activeConfig = config ?? defaultConfig
        let typography = typographyOverride ?? activeConfig.defaultTypography
        
        content
            .font(typography.font)
            .foregroundStyle(isEnabled ? typography.foregroundColor : typography.disabledColor)
            .padding(activeConfig.padding)
            .background(isEnabled ? activeConfig.backgroundColor : activeConfig.disabledBackgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: activeConfig.cornerRadius)
                    .strokeBorder(
                        // 포커스 상태에 따라 테두리 색상 변경
                        isFocused ? activeConfig.focusedBorderColor : activeConfig.borderColor,
                        lineWidth: activeConfig.borderWidth
                    )
            )
            .cornerRadius(activeConfig.cornerRadius)
            .focused(externalFocus ?? $internalFocus)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

extension View {
    /// 포커스 상태를 지원하는 TextField 스타일 적용 (내부 FocusState 사용)
    /// - Parameter config: TextField 스타일 설정
    /// - Returns: 스타일이 적용된 View
    func somniaryTextField(_ config: SomniaryTextFieldStyleConfig = .default) -> some View {
        self.modifier(FocusableTextFieldModifier(config: config))
    }

    /// 포커스 상태를 지원하는 TextField 스타일 적용 (외부 FocusState Binding 사용)
    /// - Parameters:
    ///   - config: TextField 스타일 설정
    ///   - focused: 외부에서 제어할 FocusState Binding
    /// - Returns: 스타일이 적용된 View
    ///
    /// 사용 예시:
    /// ```swift
    /// @FocusState private var isEmailFocused: Bool
    ///
    /// TextField("이메일", text: $email)
    ///     .somniaryTextField(config: .outlined, focused: $isEmailFocused)
    ///
    /// Button("포커스") {
    ///     isEmailFocused = true  // 외부에서 포커스 제어
    /// }
    /// ```
    func somniaryTextField(
        _ config: SomniaryTextFieldStyleConfig = .default,
        focused: FocusState<Bool>.Binding
    ) -> some View {
        self.modifier(FocusableTextFieldModifier(config: config, focused: focused))
    }
}
