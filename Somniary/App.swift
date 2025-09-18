//
//  SomniaryApp.swift
//  Somniary
//
//  Created by 송태환 on 9/10/25.
//

import SwiftUI

@main
struct SomniaryApp: App {

    @StateObject private var coordinator = AppCoordinator(
        appLaunchChecker: AppLaunchChecker.shared,
        tokenRepository: TokenRepository.shared
    )

    var body: some Scene {
        WindowGroup {
            coordinator.rootView
        }
    }
}
