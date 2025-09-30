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
        VStack(spacing: 16) {
            Spacer()

            Text("🎉 환영합니다!")
                .font(.title)
                .fontWeight(.semibold)

            VStack {
                Text("오늘 📝일기를 적어볼까요?")
                    .font(.title3)
                Text("아래 버튼을 눌러주세요 ⬇️")
                    .font(.title3)
            }

            Spacer()

            BarButton("홈으로 가기") {
                viewModel.send(.user(.signupCompletionTapped))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .navigationTitle("회원 가입 완료")
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
