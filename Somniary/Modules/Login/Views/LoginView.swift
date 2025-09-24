//
//  LoginView.swift
//  Somniary
//
//  Created by 송태환 on 9/11/25.
//

import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            VStack {
                TextField("가입한 이메일 입력해주세요.", text: $viewModel.email)
                    .frame(maxWidth: 200)
                    .background(Color.white)

                Button("로그인") {
                    viewModel.send(.user(.loginTapped))
                }

                Button("회원가입") {
                    viewModel.send(.user(.signUpTapped))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green)

            VStack {
                Button("애플 계정으로 로그인") {
                    viewModel.send(.user(.appleSignInTapped))
                }

                Button("구글 계정으로 로그인") {
                    viewModel.send(.user(.googleSignInTapped))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray)
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
        auth: RemoteAuthDataSource(baseURL: URL(string: "https://api.example.com")!, session: .shared),
        reducerEnvironment: LoginReducerEnvironment { UUID() }
    )
    LoginView(viewModel: .init(
        coordinator: .init(),
        environment: environment,
        executor: LoginExecutor(dataSource: RemoteAuthDataSource(baseURL: URL(string: "https://api.example.com")!, session: .shared)))
    )
}
