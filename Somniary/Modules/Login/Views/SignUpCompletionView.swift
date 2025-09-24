//
//  SignUpCompletionView.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import SwiftUI

struct SignUpCompletionView: View {

    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            Text("가입 완료")
            Spacer()
            Button("홈으로 가기") {
                viewModel.send(.user(.signupCompletionTapped))
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
    SignUpCompletionView(viewModel: .init(
        coordinator: .init(),
        environment: environment,
        executor: LoginExecutor(dataSource: RemoteAuthDataSource(baseURL: URL(string: "https://api.example.com")!, session: .shared)))
    )
}
