//
//  SomniaryTextButtonStyle+Previews.swift
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

                HStack(spacing: 16) {
                    Button("Primary Button") { }
                        .somniaryTextButtonStyle(.primary)

                    Button("Primary Button (Disabled)") { }
                        .somniaryTextButtonStyle(.primary)
                        .disabled(true)
                }
            }

            Divider()

            // Secondary 스타일
            VStack(spacing: 12) {
                Text("Secondary")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 16) {
                    Button("Secondary Button") { }
                        .somniaryTextButtonStyle(.secondary)

                    Button("Secondary Button (Disabled)") { }
                        .somniaryTextButtonStyle(.secondary)
                        .disabled(true)
                }
            }

            Divider()

            // Destructive 스타일
            VStack(spacing: 12) {
                Text("Destructive")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 16) {
                    Button("Destructive Button") { }
                        .somniaryTextButtonStyle(.destructive)

                    Button("Destructive Button (Disabled)") { }
                        .somniaryTextButtonStyle(.destructive)
                        .disabled(true)
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
            VStack(spacing: 8) {
                Text("Title Typography")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("제목 크기 텍스트 버튼") { }
                    .somniaryTextButtonStyle(.primary)
                    .typography(.title)
            }

            Divider()

            // Headline
            VStack(spacing: 8) {
                Text("Headline Typography")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("헤드라인 크기 텍스트 버튼") { }
                    .somniaryTextButtonStyle(.primary)
                    .typography(.headline)
            }

            Divider()

            // Body (기본값)
            VStack(spacing: 8) {
                Text("Body Typography (Default)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("본문 크기 텍스트 버튼") { }
                    .somniaryTextButtonStyle(.primary)
                    .typography(.body)
            }

            Divider()

            // Caption
            VStack(spacing: 8) {
                Text("Caption Typography")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("작은 크기 텍스트 버튼") { }
                    .somniaryTextButtonStyle(.primary)
                    .typography(.caption)
            }
        }
        .padding()
    }
}

#Preview("버튼 사이즈 변형") {
    ScrollView {
        VStack(spacing: 24) {
            // Fit (기본값)
            VStack(spacing: 12) {
                Text("Fit (Default) - 컨텐츠 크기에 맞춤")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 12) {
                    Button("짧은 버튼") { }
                        .somniaryTextButtonStyle(.primary)

                    Button("조금 더 긴 텍스트 버튼") { }
                        .somniaryTextButtonStyle(.primary)

                    Button("매우 긴 텍스트가 들어있는 버튼") { }
                        .somniaryTextButtonStyle(.primary)
                }
            }

            Divider()

            // Full Width
            VStack(spacing: 12) {
                Text("Full Width")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("전체 너비 텍스트 버튼") { }
                    .somniaryTextButtonStyle(.primary)
                    .buttonSize(.fullWidth)
            }

            Divider()

            // Fixed 사이즈
            VStack(spacing: 12) {
                Text("Fixed Size")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("고정 200x44") { }
                    .somniaryTextButtonStyle(.primary)
                    .buttonSize(.fixed(width: 200, height: 44))

                Button("고정 150x36") { }
                    .somniaryTextButtonStyle(.destructive)
                    .buttonSize(.fixed(width: 150, height: 36))
            }
        }
        .padding()
    }
}

#Preview("커스텀 스타일") {
    ScrollView {
        VStack(spacing: 24) {
            // 커스텀 색상
            VStack(spacing: 12) {
                Text("Custom Colors")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 16) {
                    Button("Green") { }
                        .buttonStyle(SomniaryTextButtonStyle(
                            styleConfig: SomniaryTextButtonStyleConfig(
                                typography: .init(
                                    font: .body,
                                    foregroundColor: .green,
                                    disabledColor: Color(.systemGray)
                                )
                            )
                        ))

                    Button("Purple") { }
                        .buttonStyle(SomniaryTextButtonStyle(
                            styleConfig: SomniaryTextButtonStyleConfig(
                                typography: .init(
                                    font: .body,
                                    foregroundColor: .purple,
                                    disabledColor: Color(.systemGray)
                                )
                            )
                        ))

                    Button("Orange") { }
                        .buttonStyle(SomniaryTextButtonStyle(
                            styleConfig: SomniaryTextButtonStyleConfig(
                                typography: .init(
                                    font: .body,
                                    foregroundColor: .orange,
                                    disabledColor: Color(.systemGray)
                                )
                            )
                        ))
                }
            }

            Divider()

            // 커스텀 pressedOpacity
            VStack(spacing: 12) {
                Text("Custom Pressed Opacity")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("눌렀을 때 투명도 차이를 확인해보세요")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 16) {
                    Button("Opacity 0.3") { }
                        .buttonStyle(SomniaryTextButtonStyle(
                            styleConfig: SomniaryTextButtonStyleConfig(
                                pressedOpacity: 0.3
                            )
                        ))

                    Button("Opacity 0.5") { }
                        .buttonStyle(SomniaryTextButtonStyle(
                            styleConfig: SomniaryTextButtonStyleConfig(
                                pressedOpacity: 0.5
                            )
                        ))

                    Button("Opacity 0.9") { }
                        .buttonStyle(SomniaryTextButtonStyle(
                            styleConfig: SomniaryTextButtonStyleConfig(
                                pressedOpacity: 0.9
                            )
                        ))
                }
            }
        }
        .padding()
    }
}

#Preview("실전 활용 예시") {
    ScrollView {
        VStack(spacing: 32) {
            // 네비게이션 링크 스타일
            VStack(spacing: 12) {
                Text("Navigation Links")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    Button("← 뒤로") { }
                        .somniaryTextButtonStyle(.primary)

                    Spacer()

                    Button("건너뛰기") { }
                        .somniaryTextButtonStyle(.secondary)
                }
            }

            Divider()

            // 인라인 액션
            VStack(spacing: 12) {
                Text("Inline Actions")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 8) {
                    Text("이미 계정이 있으신가요?")
                        .font(.body)

                    Button("로그인하기") { }
                        .somniaryTextButtonStyle(.primary)
                        .typography(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Divider()

            // 폼 내부 액션
            VStack(spacing: 12) {
                Text("Form Actions")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .trailing, spacing: 8) {
                    TextField("이메일", text: .constant(""))
                        .textFieldStyle(.roundedBorder)

                    Button("비밀번호를 잊으셨나요?") { }
                        .somniaryTextButtonStyle(.primary)
                        .typography(.caption)
                }
            }

            Divider()

            // 리스트 아이템 액션
            VStack(spacing: 12) {
                Text("List Item Actions")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 16) {
                    ForEach(0..<3) { index in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("항목 \(index + 1)")
                                    .font(.body)
                                    .fontWeight(.medium)

                                Text("부가 설명 텍스트")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            HStack(spacing: 12) {
                                Button("수정") { }
                                    .somniaryTextButtonStyle(.primary)
                                    .typography(.caption)

                                Button("삭제") { }
                                    .somniaryTextButtonStyle(.destructive)
                                    .typography(.caption)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            }

            Divider()

            // Footer 링크
            VStack(spacing: 12) {
                Text("Footer Links")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 16) {
                    Spacer()
                        .frame(height: 100)

                    HStack(spacing: 16) {
                        Button("서비스 약관") { }
                            .somniaryTextButtonStyle(.primary)
                            .typography(.caption)

                        Text("•")
                            .foregroundColor(.secondary)

                        Button("개인정보 처리방침") { }
                            .somniaryTextButtonStyle(.primary)
                            .typography(.caption)

                        Text("•")
                            .foregroundColor(.secondary)

                        Button("고객센터") { }
                            .somniaryTextButtonStyle(.primary)
                            .typography(.caption)
                    }
                }
            }

            Divider()

            // 모달 헤더 액션
            VStack(spacing: 12) {
                Text("Modal Header Action")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 0) {
                    HStack {
                        Text("설정")
                            .font(.title2)
                            .fontWeight(.bold)

                        Spacer()

                        Button("완료") { }
                            .somniaryTextButtonStyle(.primary)
                    }
                    .padding()
                    .background(Color(.systemGray6))

                    Spacer()
                        .frame(height: 50)
                }
            }
        }
        .padding()
    }
}
