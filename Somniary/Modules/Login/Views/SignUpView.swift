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
            TextField("이메일 입력해주세요.", text: $viewModel.email)
                .frame(maxWidth: 200)
                .background(Color.white)
                .border(.gray)

            if viewModel.email.isValidEmail {
                TextField("6자리 인증번호를 입력해주세요.", text: $viewModel.otpCode)
                    .frame(maxWidth: 200)
                    .background(Color.white)
                    .border(.gray)
            }

            Spacer()

            Button("가입하기") {
                viewModel.send(.user(.submitSignup))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
    }
}

#Preview {
    let environment = LoginEnvironment(
        auth: RemoteAuthDataSource(baseURL: URL(string: "https://api.example.com")!, session: .shared),
        reducerEnvironment: LoginReducerEnvironment { UUID() }
    )
    SignUpView(viewModel: .init(
        coordinator: .init(),
        environment: environment,
        executor: LoginExecutor(dataSource: RemoteAuthDataSource(baseURL: URL(string: "https://api.example.com")!, session: .shared)))
    )
}
