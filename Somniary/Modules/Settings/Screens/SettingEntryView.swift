//
//  SettingEntryView.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import SwiftUI

struct SettingEntryView: View {
    @ObservedObject var viewModel: SettingViewModel

    var body: some View {
        VStack {
            Button {
                viewModel.send(.user(.profileTapped))
            } label: {
                HStack {
                    Image(systemName: viewModel.state.profile?.thumbnail ?? "person.crop.circle")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 50, height: 50)

                    VStack(alignment: .leading) {
                        Text(viewModel.state.profile?.name ?? "홍길동")
                        Text(viewModel.state.profile?.email ?? "aldkjf@gmail.com")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            List {
                Button {
                    viewModel.send(.user(.notificationSettingTapped))
                } label: {
                    Text("알림 설정")
                }

                Button {
                    viewModel.send(.user(.logoutTapped))
                } label: {
                    Text("로그아웃")
                }
            }
            .listStyle(.plain)
        }
        .padding()
        .onAppear {
            viewModel.send(.lifecycle(.appeared))
        }
    }
}

#Preview {
    SettingEntryView(viewModel: AppContainer.shared.makeSettingViewModel(nil))
}
