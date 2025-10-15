//
//  SignUpView.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import SwiftUI

struct SignUpView: View {

    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            Spacer()

            VStack {
                TextInput("이메일 입력해주세요.", text: $viewModel.email)
                    .autocorrectionDisabled(true)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disabled(viewModel.state.otpCodeRequired)

                if viewModel.state.otpCodeRequired {
                    TextInput("6자리 인증번호를 입력해주세요.", text: $viewModel.otpCode)
                        .keyboardType(.numberPad)
                        .maxLength(text: $viewModel.otpCode, limit: 6)
                }

                if let errorMessage = viewModel.state.errorMessage {
                    Text(errorMessage)
                        .typography(.errorMessage)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                        .padding(.top, 6)
                }
            }

            Spacer()
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
        .padding(20)
        .navigationTitle("회원가입")
    }
}

#Preview {
    let authRepository = RemoteAuthRepository(client: NetworkClientProvider.authNetworkClient)
    let environment = LoginEnvironment(
        auth: authRepository,
        reducerEnvironment: LoginReducerEnvironment { UUID() },
        crypto: NonceGenerator.shared
    )
    SignUpView(viewModel: .init(
        coordinator: .init(),
        environment: environment,
        executor: LoginExecutor(dataSource: authRepository, tokenRepository: TokenRepository.shared))
    )
}
