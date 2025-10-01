//
//  AppCoordinator.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import SwiftUI

/// App Root Coodinator
/// 딥링크 핸들러 및 의존성 초기화
final class AppCoordinator: ObservableObject, CoordinatorFinishDelegate {

    private let deeplinkCoordinator = DeeplinkCoordinator()
    @Published private var startCoordinator: any Coordinator

    init(appLaunchChecker: AppLaunchChecking, tokenRepository: TokenReposable) {
        // TODO: 딥링크를 지원하는 coordinator 등록
        deeplinkCoordinator.addHandlers([])

        if appLaunchChecker.isFirstLaunch || tokenRepository.getAccessToken() == nil {
            self.startCoordinator = LoginCoordinator()
        } else {
            self.startCoordinator = TabBarCoordinator()
        }

        self.startCoordinator.finishDelegate = self
    }

    @MainActor
    @ViewBuilder
    var rootView: some View {
        AnyView(self.startCoordinator.rootView)
            .onOpenURL { url in
                self.deeplinkCoordinator.handle(url)
            }
    }

    /// 코디네이터 플로우가 종료된 경우 네비게이션 처리
    func didFinish(childCoordinator: any Coordinator) {
        switch childCoordinator {
        case is LoginCoordinator:
            self.navigateToHome()
        case is TabBarCoordinator:
            // undefined yet
            break;
        default:
            break
        }
    }

    private func navigateToHome() {
        self.startCoordinator = TabBarCoordinator()
    }
}
