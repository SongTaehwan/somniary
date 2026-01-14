//
//  LoginView.swift
//  Somniary
//
//  Created by 송태환 on 9/11/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "moon.fill")
                .resizable()
                .renderingMode(.template)
                .frame(width: 100, height: 100)
                .foregroundStyle(.yellow)

            SignInWithAppleButton(.signIn) { request in
                viewModel.configureAppleSignInRequest(request)
            } onCompletion: { result in
                viewModel.handleAppleSignInCompletion(result)
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 56)
            .cornerRadius(12)

            HStack {
                Text("처음 방문 하셨나요?")
                    .font(.title2)
                    .foregroundStyle(Asset.Colors.Text.secondary.swiftUIColor)

                BaseButton("회원 가입") {
                    viewModel.send(.user(.signUpTapped))
                }
                .somniaryTextButtonStyle(.init(
                    typography: .init(
                        font: .title2,
                        foregroundColor: Asset.Colors.primary.swiftUIColor
                    ),
                    buttonSize: .fit
                ))
            }

            HStack(spacing: 12) {
                Separator()
                Text("OR")
                    .font(.caption1)
                    .foregroundStyle(Asset.Colors.Text.tertiary.swiftUIColor)
                    .opacity(0.25)
                Separator()
            }

            VStack {
                TextInput("이메일 입력해주세요.", text: $viewModel.email)
                    .autocorrectionDisabled(true)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)

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

            BaseButton("로그인") {
                if viewModel.state.otpCodeRequired && viewModel.state.canSubmit {
                    viewModel.send(.user(.submitLogin))
                } else {
                    viewModel.send(.user(.loginTapped))
                }
            }
            .somniaryButtonStyle(.primary)
            .disabled(viewModel.email.isValidEmail == false)
            .disabled(viewModel.state.otpCodeRequired && viewModel.state.canSubmit == false)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .background(Asset.Colors.Background.primary.swiftUIColor)
        .onReceive(viewModel.uiEvent) { event in
            switch event {
            case .toast(let message):
                print("[toast] \(message)")
            }
        }
    }
}

#Preview {
    LoginView(viewModel: AppContainer.shared.makeLoginViewModel(nil))
}
