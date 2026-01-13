//
//  ConfirmDialog.swift
//  Somniary
//
//  Created by 송태환 on 1/13/26.
//

import SwiftUI

struct ConfirmDialog: View {
    let title: String
    let message: String
    let cancelTitle: String
    let confirmTitle: String
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        DialogOverlay {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(title)
                        .font(.title1.weight(.bold))
                        .foregroundStyle(Asset.Colors.Text.primary.swiftUIColor)

                    Text(message)
                        .font(.title2.weight(.medium))
                        .foregroundStyle(Asset.Colors.Text.secondary.swiftUIColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                .padding(.bottom, 8)
                .padding(.horizontal, 20)

                HStack(spacing: 8) {
                    Button(action: {
                        onCancel()
                    }, label: {
                        Text(cancelTitle)
                            .font(.title2.weight(.medium))
                            .foregroundStyle(Asset.Colors.Text.tertiary.swiftUIColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                            .background(Asset.Colors.Button.Background.primary.swiftUIColor)
                    })
                    .clipShape(.rect(cornerRadius: 10))

                    Button(action: {
                        onConfirm()
                    }, label: {
                        Text(confirmTitle)
                            .font(.title2.weight(.medium))
                            .foregroundStyle(Asset.Colors.Text.primary.swiftUIColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                            .background(Asset.Colors.primary.swiftUIColor)
                    })
                    .clipShape(.rect(cornerRadius: 10))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Asset.Colors.Background.primary.swiftUIColor)
            .clipShape(.rect(cornerRadius: 16))
            .frame(maxWidth: 280)
        }
    }
}

#Preview {
    ConfirmDialog(
        title: "내용을 수정할까요?",
        message: "확인을 누르면 내용이 수정됩니다.",
        cancelTitle: "취소",
        confirmTitle: "수정하기",
        onCancel: {
            print("취소")
        },
        onConfirm: {
            print("수정")
        }
    )
}
