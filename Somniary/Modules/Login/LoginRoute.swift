//
//  LoginRoute.swift
//  Somniary
//
//  Created by 송태환 on 9/11/25.
//

import Foundation

// TODO: Login, Signup 플로우 분리할지?
enum LoginRoute: Routable {
    /// 로그인 화면
    case login
    case signup
    case verification
    case completion

    var navigationType: NavigationType {
        switch self {
        case .login, .verification, .completion: return .push
        case .signup: return .present(.sheet())
        }
    }
}
