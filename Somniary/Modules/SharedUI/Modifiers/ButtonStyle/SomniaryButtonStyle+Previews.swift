//
//  SomniaryButtonStyle+Previews.swift
//  Somniary
//
//  Created by 송태환 on 10/9/25.
//

import SwiftUI

#Preview("기본 스타일 프리셋") {
    ScrollView {
        VStack(spacing: 24) {
            // Primary 스타일
            VStack(spacing: 12) {
                Text("Primary")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Primary Button") { }
                    .somniaryButtonStyle(.primary)

                Button("Primary Button (Disabled)") { }
                    .somniaryButtonStyle(.primary)
                    .disabled(true)
            }

            Divider()

            // Secondary 스타일
            VStack(spacing: 12) {
                Text("Secondary")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Secondary Button") { }
                    .somniaryButtonStyle(.secondary)

                Button("Secondary Button (Disabled)") { }
                    .somniaryButtonStyle(.secondary)
                    .disabled(true)
            }

            Divider()

            // Destructive 스타일
            VStack(spacing: 12) {
                Text("Destructive")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Destructive Button") { }
                    .somniaryButtonStyle(.destructive)

                Button("Destructive Button (Disabled)") { }
                    .somniaryButtonStyle(.destructive)
                    .disabled(true)
            }
        }
        .padding()
    }
}

#Preview("버튼 사이즈 변형") {
    ScrollView {
        VStack(spacing: 24) {
            // Full Width (기본값)
            VStack(spacing: 12) {
                Text("Full Width (Default)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Full Width Button") { }
                    .somniaryButtonStyle(.primary)
            }

            Divider()

            // Fit 사이즈
            VStack(spacing: 12) {
                Text("Fit")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Fit Button") { }
                    .somniaryButtonStyle(.primary)
                    .buttonSize(.fit)
            }

            Divider()

            // Fixed 사이즈
            VStack(spacing: 12) {
                Text("Fixed Size")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Fixed 200x50") { }
                    .somniaryButtonStyle(.primary)
                    .buttonSize(.fixed(width: 200, height: 50))

                Button("Fixed 150x60") { }
                    .somniaryButtonStyle(.secondary)
                    .buttonSize(.fixed(width: 150, height: 60))
            }

            Divider()

            // 여러 버튼 배치 (Fit)
            VStack(spacing: 12) {
                Text("Multiple Buttons (Fit)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 12) {
                    Button("Cancel") { }
                        .somniaryButtonStyle(.secondary)
                        .buttonSize(.fit)

                    Button("Confirm") { }
                        .somniaryButtonStyle(.primary)
                        .buttonSize(.fit)
                }
            }
        }
        .padding()
    }
}

#Preview("타이포그래피 변형") {
    ScrollView {
        VStack(spacing: 24) {
            // Title
            Button("Title Typography") { }
                .somniaryButtonStyle(.primary)
                .typography(.title)

            // Headline
            Button("Headline Typography") { }
                .somniaryButtonStyle(.primary)
                .typography(.headline)

            // Body (기본값)
            Button("Body Typography (Default)") { }
                .somniaryButtonStyle(.primary)
                .typography(.body)

            // Caption
            Button("Caption Typography") { }
                .somniaryButtonStyle(.primary)
                .typography(.caption)
        }
        .padding()
    }
}

#Preview("커스텀 스타일") {
    ScrollView {
        VStack(spacing: 24) {
            // 커스텀 배경색
            VStack(spacing: 12) {
                Text("Custom Background Color")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Custom Green") { }
                    .buttonStyle(SomniaryButtonStyle(
                        styleConfig: SomniaryButtonStyleConfig(
                            backgroundColor: .green
                        )
                    ))

                Button("Custom Purple") { }
                    .buttonStyle(SomniaryButtonStyle(
                        styleConfig: SomniaryButtonStyleConfig(
                            backgroundColor: .purple
                        )
                    ))
            }

            Divider()

            // 커스텀 cornerRadius
            VStack(spacing: 12) {
                Text("Custom Corner Radius")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Corner Radius 4") { }
                    .buttonStyle(SomniaryButtonStyle(
                        styleConfig: SomniaryButtonStyleConfig(
                            backgroundColor: .primary,
                            cornerRadius: 4
                        )
                    ))

                Button("Corner Radius 24") { }
                    .buttonStyle(SomniaryButtonStyle(
                        styleConfig: SomniaryButtonStyleConfig(
                            backgroundColor: .primary,
                            cornerRadius: 24
                        )
                    ))
            }

            Divider()

            // 커스텀 패딩
            VStack(spacing: 12) {
                Text("Custom Padding")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Small Padding") { }
                    .buttonStyle(SomniaryButtonStyle(
                        styleConfig: SomniaryButtonStyleConfig(
                            backgroundColor: .primary,
                            padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
                        )
                    ))

                Button("Large Padding") { }
                    .buttonStyle(SomniaryButtonStyle(
                        styleConfig: SomniaryButtonStyleConfig(
                            backgroundColor: .primary,
                            padding: EdgeInsets(top: 24, leading: 32, bottom: 24, trailing: 32)
                        )
                    ))
            }
        }
        .padding()
    }
}

#Preview("실전 활용 예시") {
    ScrollView {
        VStack(spacing: 24) {
            // 로그인 화면 스타일
            VStack(spacing: 12) {
                Text("Login Screen")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("로그인") { }
                    .somniaryButtonStyle(.primary)

                Button("회원가입") { }
                    .somniaryButtonStyle(.secondary)
                    .buttonSize(.fit)
            }

            Divider()

            // 모달 액션 스타일
            VStack(spacing: 12) {
                Text("Modal Actions")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 12) {
                    Button("취소") { }
                        .somniaryButtonStyle(.secondary)
                        .buttonSize(.fit)

                    Button("확인") { }
                        .somniaryButtonStyle(.primary)
                        .buttonSize(.fit)
                }

                HStack(spacing: 12) {
                    Button("취소") { }
                        .somniaryButtonStyle(.secondary)
                        .buttonSize(.fit)

                    Button("삭제") { }
                        .somniaryButtonStyle(.destructive)
                        .buttonSize(.fit)
                }
            }

            Divider()

            // 카드 액션 스타일
            VStack(spacing: 12) {
                Text("Card Actions")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Card Title")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Some description text goes here...")
                        .font(.body)
                        .foregroundColor(.secondary)

                    HStack(spacing: 8) {
                        Button("자세히") { }
                            .somniaryButtonStyle(.secondary)
                            .buttonSize(.fit)
                            .typography(.caption)

                        Button("시작하기") { }
                            .somniaryButtonStyle(.primary)
                            .buttonSize(.fit)
                            .typography(.caption)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
        .padding()
    }
}
