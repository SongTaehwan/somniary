//
//  NavigationFlowView.swift
//  Somniary
//
//  Created by 송태환 on 9/11/25.
//

import SwiftUI

struct NavigationFlowView<Coordinator: FlowCoordinator>: View {
    @StateObject private var coordinator: Coordinator
    @StateObject private var navigationController: NavigationController<Coordinator.Route>

    private var content: () -> any View

    init(coordinator: Coordinator, navigationController: NavigationController<Coordinator.Route>, content: @escaping () -> any View) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self._navigationController = StateObject(wrappedValue: navigationController)
        self.content = content
    }

    var body: some View {
        NavigationStack(path: $navigationController.path) {
            AnyView(content())
                .navigationDestination(for: Coordinator.Route.self) { route in
                    self.coordinator.destination(for: route)
                }
        }
        .sheet(isPresented: navigationController.isPresnting(with: .sheet)) {
            presentableView
        }
        .fullScreenCover(isPresented: navigationController.isPresnting(with: .fullScreenCover)) {
            presentableView
        }
        // 자식 코디네이터 플로우
        .sheet(isPresented: coordinator.shouldPresentChild(from: navigationController)) {
            if let childCoordinator = coordinator.childCoordinator {
                AnyView(childCoordinator.rootView)
            }
        }
    }

    @ViewBuilder
    private var presentableView: some View {
        if let route = coordinator.topNavigationController.presentedRoute {
            NavigationFlowView(
                coordinator: coordinator,
                navigationController: coordinator.topNavigationController
            ) {
                coordinator.destination(for: route)
            }
        }
    }
}
