//
//  SignUpScreen.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import SwiftUI

struct SignUpScreen: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading) {
                Text("반가워요,")
                Text("계정으로 이메일을 입력해주세요")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.heading1)
            .foregroundStyle(Asset.Colors.Text.primary.swiftUIColor)

            VStack(spacing: 8) {
                TextInput("이메일 입력해주세요.", text: $viewModel.email)
                    .autocorrectionDisabled(true)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disabled(viewModel.state.otpCodeRequired)

                if viewModel.state.otpCodeRequired {
                    VStack {
                        TextInput("6자리 인증번호를 입력해주세요.", text: $viewModel.otpCode)
                            .keyboardType(.numberPad)
                            .maxLength(text: $viewModel.otpCode, limit: 6)

                        Text("발송된 OTP 번호를 입력해주세요")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.caption1)
                            .foregroundStyle(Asset.Colors.Text.secondary.swiftUIColor)
                            .padding(.leading, 8)
                    }
                }

                if let errorMessage = viewModel.state.errorMessage {
                    Text(errorMessage)
                        .typography(.errorMessage)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                        .padding(.top, 8)
                }
            }

            Spacer()

            if viewModel.state.otpCodeRequired == false {
                BaseButton("인증번호 요청") {
                    viewModel.send(.user(.requestOtpCodeTapped))
                }
                .somniaryButtonStyle(.primary)
                .disabled(viewModel.state.isValidEmail == false)
            } else {
                BaseButton("회원 가입") {
                    if viewModel.state.canSubmit {
                        viewModel.send(.user(.submitSignup))
                    }
                }
                .somniaryButtonStyle(.primary)
                .disabled(viewModel.state.canSubmit == false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .background(Asset.Colors.Background.primary.swiftUIColor)
        .navigationTitle("회원가입")
    }
}

#Preview {
    SignUpScreen(viewModel: AppContainer.shared.makeLoginViewModel(nil))
}
