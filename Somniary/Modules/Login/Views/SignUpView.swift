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

                if viewModel.email.isValidEmail {
                    TextInput("6자리 인증번호를 입력해주세요.", text: $viewModel.otpCode)
                        .keyboardType(.numberPad)
                        .maxLength(text: $viewModel.otpCode, limit: 6)
                }
            }

            Spacer()

            BarButton(viewModel.state.canSubmit ? "회원 가입" : "인증번호 요청") {
                if viewModel.state.canSubmit {
                    viewModel.send(.user(.submitSignup))
                } else {
                    viewModel.send(.user(.requestOtpCodeTapped))
                }
            }
            .disabled(viewModel.state.canSubmit == false)
            .somniaryButtonStyle(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .navigationTitle("회원가입")
    }
}

#Preview {
    let environment = LoginEnvironment(
        auth: RemoteAuthRepository(client: NetworkClientProvider.authNetworkClient),
        reducerEnvironment: LoginReducerEnvironment { UUID() }
    )
    SignUpView(viewModel: .init(
        coordinator: .init(),
        environment: environment,
        executor: LoginExecutor(dataSource: RemoteAuthRepository(client: NetworkClientProvider.authNetworkClient)))
    )
}
