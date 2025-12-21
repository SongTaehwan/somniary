//
//  SettingCoordinator.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import SwiftUI

final class SettingCoordinator: FlowCoordinator {
    typealias Route = SettingRoute

    weak var finishDelegate: CoordinatorFinishDelegate?

    @Published var childCoordinator: (any Coordinator)?
    @Published var childPresentationType: PresentationType?
    @Published var navigationControllers = [NavigationController<Route>]()

    init() {
        self.initializeRootNavigationController()
    }

    deinit {
        print("Deinit SettingCoordinator")
    }

    func destination(for route: Route) -> some View {
        switch route {
        case .main:
            SettingEntryView()
        @unknown default:
            EmptyView()
        }
    }

    var rootView: some View {
        NavigationFlowView(
            coordinator: self,
            navigationController: self.rootNavigationController
        ) {
            SettingEntryView()
        }
    }
}
