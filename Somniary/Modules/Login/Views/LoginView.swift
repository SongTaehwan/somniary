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
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                Image(systemName: "moon.fill")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.yellow)

                Text("Welcome!")
                    .font(.title)
                    .fontWeight(.bold)
            }

            VStack(spacing: 12) {
                SignInWithAppleButton(.signIn) { request in
                    viewModel.configureAppleSignInRequest(request)
                } onCompletion: { result in
                    viewModel.handleAppleSignInCompletion(result)
                }
                .signInWithAppleButtonStyle(.black)
                .frame(maxHeight: 56)
                .cornerRadius(12)

                BaseButton("구글 계정으로 로그인") {
                    viewModel.send(.user(.googleSignInTapped))
                }
                .somniaryButtonStyle(.primary)
            }

            HStack(spacing: 12) {
                Separator()
                Text("OR")
                    .opacity(0.25)
                Separator()
            }

            TextInput("이메일 입력해주세요.", text: $viewModel.email)
                .autocorrectionDisabled(true)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)

            BaseButton("로그인") {
                viewModel.send(.user(.loginTapped))
            }
            .somniaryButtonStyle(.primary)
            .disabled(viewModel.email.isValidEmail == false)

            Separator()

            HStack {
                Text("처음 방문 하셨나요?")
                BaseButton("회원 가입") {
                    viewModel.send(.user(.signUpTapped))
                }
                .somniaryTextButtonStyle(.primary)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .onReceive(viewModel.uiEvent) { event in
            switch event {
            case .toast(let message):
                print(message)
            }
        }
    }
}

#Preview {
    let environment = LoginEnvironment(
        auth: RemoteAuthRepository(client: NetworkClientProvider.authNetworkClient),
        reducerEnvironment: LoginReducerEnvironment { UUID() },
        crypto: NonceGenerator.shared
    )
    LoginView(viewModel: .init(
        coordinator: .init(),
        environment: environment,
        executor: LoginExecutor(dataSource: RemoteAuthRepository(client: NetworkClientProvider.authNetworkClient)))
    )
}
