//
//  SettingRoute.swift
//  Somniary
//
//  Created by 송태환 on 12/21/25.
//

import Foundation

enum SettingRoute: Routable {
    /// 설정 화면
    case main
    /// 프로필 설정
    case profile
    /// 알람 설정
    case notification

    var navigationType: NavigationType {
        switch self {
        case .main: return .push
        case .profile: return .push
        case .notification: return .push
        }
    }
}
