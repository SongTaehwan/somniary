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

            TextInput("이메일 입력해주세요.", text: $viewModel.email)
                .autocorrectionDisabled(true)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)

            Spacer()

            BaseButton("로그인") {
                viewModel.send(.user(.loginTapped))
            }
            .somniaryButtonStyle(.primary)
            .disabled(viewModel.email.isValidEmail == false)
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
