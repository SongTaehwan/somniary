//
//  ButtonSize.swift
//  Somniary
//
//  Created by 송태환 on 10/5/25.
//

import Foundation

enum ButtonSize: Equatable {
    /// 컨텐츠 크기에 맞춤 (기본값)
    case fit
    /// 가로 full width
    case fullWidth
    /// 커스텀 width
    case fixed(width: CGFloat?, height: CGFloat?)

    var width: CGFloat? {
        if case let .fixed(width, _) = self {
            return width
        }

        return nil
    }

    var height: CGFloat? {
        if case let .fixed(_, height) = self {
            return height
        }

        return nil
    }

    var maxWidth: CGFloat? {
        switch self {
        case .fit:
            return nil
        case .fullWidth:
            return .infinity
        case let .fixed(width, _):
            return width
        }
    }
}
