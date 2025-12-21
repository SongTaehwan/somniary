//
//  SettingCoordinator.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import SwiftUI

protocol SettingCoordinatorDependency {
    @MainActor func makeSettingViewModel(_ coordinator: (any FlowCoordinator<SettingRoute>)?) -> SettingViewModel
}

final class SettingCoordinator: FlowCoordinator {
    typealias Route = SettingRoute

    weak var finishDelegate: CoordinatorFinishDelegate?

    @Published var childCoordinator: (any Coordinator)?
    @Published var childPresentationType: PresentationType?
    @Published var navigationControllers = [NavigationController<Route>]()

    @MainActor
    private lazy var settingViewModel: SettingViewModel = {
        return self.dependency.makeSettingViewModel(self)
    }()

    private let dependency: SettingCoordinatorDependency

    init(dependency container: SettingCoordinatorDependency) {
        self.dependency = container
        self.initializeRootNavigationController()
    }

    deinit {
        print("Deinit SettingCoordinator")
    }

    func destination(for route: Route) -> some View {
        switch route {
        case .main:
            SettingEntryView(viewModel: self.settingViewModel)
        @unknown default:
            EmptyView()
        }
    }

    var rootView: some View {
        NavigationFlowView(
            coordinator: self,
            navigationController: self.rootNavigationController
        ) {
            SettingEntryView(viewModel: self.settingViewModel)
        }
    }
}
