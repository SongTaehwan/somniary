//
//  ScalableSwitchToggleStyle.swift
//  Somniary
//
//  Created by 송태환 on 1/13/26.
//

import SwiftUI

struct ScalableSwitchToggleStyle: ToggleStyle {
    let width: CGFloat
    let height: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(configuration.isOn ? Asset.Colors.primary.swiftUIColor : Color.gray.opacity(0.4))
                    .frame(width: width, height: height)

                Circle()
                    .fill(Asset.Colors.Text.primary.swiftUIColor)
                    .shadow(radius: 1)
                    .frame(width: height - 4, height: height - 4)
                    .padding(2)
            }
            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: configuration.isOn)
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}

#Preview {
    InteractivePreview()

    Divider()

    Group {
        Text("ON 상태")
        Toggle(isOn: .constant(true)) {
            Text("취소된 예약 안보기")
        }
        .toggleStyle(ScalableSwitchToggleStyle(width: 48, height: 28))

        Text("OFF 상태")
        Toggle(isOn: .constant(false)) {
            Text("취소된 예약 안보기")
        }
        .toggleStyle(ScalableSwitchToggleStyle(width: 48, height: 28))
    }
    .padding(.horizontal, 20)
}

private struct InteractivePreview: View {
    @State private var toggle = false

    var body: some View {
        VStack {
            Text("인터랙티브 (클릭 가능)")
                .font(.caption)
                .foregroundColor(.secondary)

            Toggle(isOn: $toggle) {
                Text("취소된 예약 안보기")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Asset.Colors.primary.swiftUIColor)
            }
            .toggleStyle(ScalableSwitchToggleStyle(width: 48, height: 28))
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
    }
}
