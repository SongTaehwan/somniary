//
//  LoginVerificationView.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import SwiftUI

struct LoginVerificationView: View {
    
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            Spacer()
            Text("발송된 OTP 코드를 입력해주세요.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
                .padding(.leading, 8)

            TextInput("6자리 인증번호를 입력해주세요.", text: $viewModel.otpCode)
                .maxLength(text: $viewModel.otpCode, limit: 6)

            if let errorMessage = viewModel.state.errorMessage {
                Text(errorMessage)
                    .typography(.errorMessage)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
                    .padding(.top, 6)
            }

            Spacer()
            Spacer()

            BaseButton("로그인하기") {
                viewModel.send(.user(.submitLogin))
            }
            .somniaryButtonStyle(.primary)
            .disabled(viewModel.state.canSubmit == false)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .navigationTitle("로그인 인증")
    }
}

#Preview {
    let environment = LoginEnvironment(
        auth: RemoteAuthRepository(client: NetworkClientProvider.authNetworkClient),
        reducerEnvironment: LoginReducerEnvironment { UUID() }
    )
    LoginVerificationView(viewModel: .init(
        coordinator: .init(),
        environment: environment,
        executor: LoginExecutor(dataSource: RemoteAuthRepository(client: NetworkClientProvider.authNetworkClient)))
    )
}
