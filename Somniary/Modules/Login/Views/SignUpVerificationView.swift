//
//  SignUpVerificationView.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import SwiftUI

struct SignUpVerificationView: View {
    
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            TextField("인증번호 6자리를 입력해주세요", text: $viewModel.otpCode)
            Spacer()
            Button("로그인하기") {
                viewModel.send(.user(.submitLogin))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .navigationTitle("Verification")
    }
}

#Preview {
    let environment = LoginEnvironment(
        auth: RemoteAuthDataSource(baseURL: URL(string: "https://api.example.com")!, session: .shared),
        reducerEnvironment: LoginReducerEnvironment { UUID() }
    )
    SignUpVerificationView(viewModel: .init(
        coordinator: .init(),
        environment: environment,
        executor: LoginExecutor(dataSource: RemoteAuthDataSource(baseURL: URL(string: "https://api.example.com")!, session: .shared)))
    )
}
