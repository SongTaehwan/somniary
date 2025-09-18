//
//  AppCoordinator.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import SwiftUI

/// App Root Coodinator
/// 딥링크 핸들러 및 의존성 초기화
final class AppCoordinator: ObservableObject {

    private let deeplinkCoordinator = DeeplinkCoordinator()
    private var startCoordinator: any Coordinator

    init(appLaunchChecker: AppLaunchChecking, tokenRepository: TokenReposable) {
        // TODO: 딥링크를 지원하는 coordinator 등록
        deeplinkCoordinator.addHandlers([])

        if appLaunchChecker.isFirstLaunch || tokenRepository.getAccessToken() == nil {
            self.startCoordinator = EmptyCoordinator()
        } else {
            self.startCoordinator = TabBarCoordinator()
        }
    }

    @MainActor
    @ViewBuilder
    var rootView: some View {
        AnyView(self.startCoordinator.rootView)
            .onOpenURL { url in
                self.deeplinkCoordinator.handle(url)
            }
    }
}
