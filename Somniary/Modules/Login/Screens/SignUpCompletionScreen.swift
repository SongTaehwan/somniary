//
//  SignUpCompletionScreen.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import SwiftUI

struct SignUpCompletionScreen: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(uiImage: Asset.Icons.congret.image)
                .resizable()
                .renderingMode(.original)
                .frame(width: 147, height: 155)

            VStack(spacing: 8) {
                Text("환영합니다!")
                Text("오늘의 꿈 일기를 들려주세요!")
            }
            .font(.heading1)
            .foregroundStyle(Asset.Colors.Text.primary.swiftUIColor)

            Spacer()

            BaseButton("홈으로 가기") {
                viewModel.send(.user(.signupCompletionTapped))
            }
            .somniaryButtonStyle(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .background(Asset.Colors.Background.primary.swiftUIColor)
        .navigationTitle("회원 가입 완료")
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SignUpCompletionScreen(viewModel: AppContainer.shared.makeLoginViewModel(nil))
}
