//
//  SomniaryTextFieldStyle+Previews.swift
//  Somniary
//
//  Created by 송태환 on 10/9/25.
//

import SwiftUI

#Preview {
    struct PreviewContainer: View {
        
        @State private var email = ""
        @State private var password = ""
        @State private var username = ""

        @FocusState private var isEmailFocused: Bool
        @FocusState private var isPasswordFocused: Bool

        var body: some View {
            ScrollView {
                VStack(spacing: 30) {
                    // 외부 FocusState 제어 예시
                    VStack(alignment: .leading, spacing: 16) {
                        Text("External FocusState Control")
                            .font(.headline)

                        TextField("이메일", text: $email)
                            .somniaryTextField(.outlined, focused: $isEmailFocused)

                        TextField("비밀번호", text: $password)
                            .somniaryTextField(.emphasized, focused: $isPasswordFocused)

                        HStack(spacing: 12) {
                            Button("Email 포커스") {
                                isEmailFocused = true
                            }
                            .buttonStyle(.bordered)

                            Button("Password 포커스") {
                                isPasswordFocused = true
                            }
                            .buttonStyle(.bordered)

                            Button("포커스 해제") {
                                isEmailFocused = false
                                isPasswordFocused = false
                            }
                            .buttonStyle(.bordered)
                        }

                        Text("Email Focused: \(isEmailFocused ? "✓" : "✗")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("Password Focused: \(isPasswordFocused ? "✓" : "✗")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    // 내부 FocusState (자동 관리)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Internal FocusState (자동 관리)")
                            .font(.headline)

                        TextField("Username", text: $username)
                            .somniaryTextField(.outlined)

                        TextField("Default Style", text: .constant(""))
                            .somniaryTextField(.default)

                        TextField("Emphasized Style", text: .constant(""))
                            .somniaryTextField(.emphasized)

                        TextField("Error Style", text: .constant(""))
                            .somniaryTextField(.error)
                    }

                    Divider()

                    // Typography 오버라이드
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Typography Override")
                            .font(.headline)

                        TextField("Headline Typography", text: .constant(""))
                            .somniaryTextField(.outlined)
                            .typography(.headline)

                        TextField("Caption Typography", text: .constant(""))
                            .somniaryTextField(.outlined)
                            .typography(.caption)
                    }

                    Divider()

                    // Disabled 상태
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Disabled State")
                            .font(.headline)

                        TextField("Disabled Default", text: .constant("Sample Text"))
                            .somniaryTextField(.default)
                            .disabled(true)

                        TextField("Disabled Outlined", text: .constant("Sample Text"))
                            .somniaryTextField(.outlined)
                            .disabled(true)
                    }
                }
                .padding()
            }
        }
    }

    return PreviewContainer()
}
