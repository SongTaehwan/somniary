//
//  LoginRoute.swift
//  Somniary
//
//  Created by 송태환 on 9/11/25.
//

import Foundation

enum LoginRoute: Routable {
    /// 로그인 화면
    case main
    /// 회원가입 화면
    case signup
    /// 이메일 인증 화면
    case verification
    /// 가입 완료 화면
    case completion

    var navigationType: NavigationType {
        switch self {
        case .main, .verification, .signup, .completion: return .push
        }
    }
}
