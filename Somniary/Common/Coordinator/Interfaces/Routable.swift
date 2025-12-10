//
//  Routable.swift
//  Somniary
//
//  Created by 송태환 on 9/10/25.
//

import SwiftUI

/// Flow 라우트 모델 프로토콜
/// 프로토콜 채택 후 라우팅 case 정의
protocol Routable: Hashable {
    var navigationType: NavigationType { get }
}

/// 네비게이션 유형
enum NavigationType {
    /// 일반적인 네비게이션 스타일
    case push
    /// Overlay 스타일
    case present(PresentationType)
}

extension NavigationType {
    var presentationType: PresentationType? {
        guard case .present(let presentationType) = self else {
            return nil
        }

        return presentationType
    }
}

/// Overlay 세부 타입
enum PresentationType {
    /// 화면 부분 Overlay
    case sheet(Set<PresentationDetent>? = nil)
    /// 화면 전체 Overlay
    case fullScreenCover
}

extension PresentationType {

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case (.sheet, .sheet):
                return true
            case (.fullScreenCover, .fullScreenCover):
                return true
            default:
                return false
        }
    }

    /// sheet detent
    var detents: Set<PresentationDetent>? {
        guard case .sheet(let detents) = self else {
            return nil
        }

        return detents
    }
}
