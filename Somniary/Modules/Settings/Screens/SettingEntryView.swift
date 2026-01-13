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
            HStack {
                Text(viewModel.state.profile?.email ?? "aldkjf@gmail.com")
                    .font(.title2)
                Spacer()
                Button {
                    viewModel.send(.user(.logoutTapped))
                } label: {
                    Text("로그아웃")
                        .font(.caption1)
                        .foregroundStyle(Asset.Colors.Text.tertiary.swiftUIColor)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .strokeBorder(Asset.Colors.Button.Background.outline.swiftUIColor, lineWidth: 1)
                        }
                }
            }

            Separator()
                .padding(.vertical, 20)

            HStack {
                Text("알림 설정")
                    .font(.title2)
                Spacer()
                Toggle("", isOn: $viewModel.isToggle)
                    .foregroundStyle(Asset.Colors.primary.swiftUIColor)
                    .toggleStyle(ScalableSwitchToggleStyle(width: 40, height: 24))
            }

            Separator()
                .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .background(Asset.Colors.Background.primary.swiftUIColor)
        .foregroundStyle(Asset.Colors.Text.primary.swiftUIColor)
        .onAppear {
            viewModel.send(.lifecycle(.appeared))
        }
    }
}

#Preview {
    SettingEntryView(viewModel: AppContainer.shared.makeSettingViewModel(nil))
}
