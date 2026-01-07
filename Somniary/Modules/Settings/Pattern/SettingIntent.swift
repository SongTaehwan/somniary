//
//  SettingIntent.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import Foundation

enum SettingIntent: Equatable {
    enum LifecycleIntent: Equatable {
        case appeared
    }

    enum UserIntent: Equatable {
        case profileTapped
        case notificationSettingTapped
        case logoutTapped
        case profileEditConfirmTapped
    }

    enum SystemExtenralIntent: Equatable {}

    enum SystemInternalIntent: Equatable {
        case logoutResponse(Result<VoidResponse, LogoutUseCaseError>)
        case profileUpdateResponse
        case profileResponse
    }

    enum NavigationIntent: Equatable {
        case routeToHome
        case routeToProfileEdit
        case routeToNotificationSettings
    }

    // Lifecycle(View)
    case lifecycle(LifecycleIntent)

    // User(Gesture)
    case user(UserIntent)

    // External(System) - 푸시, 딥링크, 앱 설정 변경, 네트워크 재연결
    case systemExtenral(SystemExtenralIntent)

    // Internal(Effect)
    case systemInternal(SystemInternalIntent)
}
