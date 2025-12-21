//
//  AppCoordinator.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import SwiftUI

protocol AppCoordinatorDependency {
    func makeDeeplinkCoordinator() -> DeeplinkCoordinator
    func makeStartFlowCoodinator() -> any Coordinator
}

/// App Root Coodinator
final class AppCoordinator: ObservableObject, CoordinatorFinishDelegate {
    @Published private var startCoordinator: any Coordinator

    private let deeplinkCoordinator: DeeplinkCoordinator
    private let denpdency: AppCoordinatorDependency

    init(container: AppCoordinatorDependency) {
        self.denpdency = container
        self.deeplinkCoordinator = container.makeDeeplinkCoordinator()
        self.startCoordinator = container.makeStartFlowCoodinator()
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
        self.startCoordinator.finishDelegate = self
    }
}
