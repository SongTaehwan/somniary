//
//  EmptyCoordinator.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import SwiftUI

final class EmptyCoordinator: FlowCoordinator {
    enum EmptyRoute: Routable {
        case scene1
        case scene2

        var navigationType: NavigationType {
            return .push
        }
    }

    weak var finishDelegate: CoordinatorFinishDelegate?

    @Published var childCoordinator: (any Coordinator)?
    @Published var childPresentationType: PresentationType?
    @Published var navigationControllers = [NavigationController<EmptyRoute>]()

    init() {
        self.initializeRootNavigationController()
    }

    deinit {
        print("Deinit LoginCoordinator")
    }

    func destination(for route: EmptyRoute) -> some View {
        switch route {
        case .scene1: Text("Scene 1")
        case .scene2: Button(action: {}) { Text("Scene 2") }
        }
    }

    var rootView: some View {
        EmptyView()
    }
}
