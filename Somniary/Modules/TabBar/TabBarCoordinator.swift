//
//  TabBarCoordinator.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import SwiftUI

final class TabBarCoordinator: CompositionCoordinator {

    /// Tab item configuration
    struct TabItemConfig: Identifiable, Hashable {
        let tab: Tab
        let title: String
        let systemImage: String

        var id: Self { self }
    }

    /// Tab model
    enum Tab: Hashable, Identifiable, CaseIterable {
        case home
        case diary
        case settings

        var id: Self { self }

        var title: String {
            switch self {
            case .home: "홈"
            case .diary: "기록"
            case .settings: "설정"
            }
        }

        var systemImage: String {
            switch self {
            case .home: "house.fill"
            case .diary: "book.closed.fill"
            case .settings: "gearshape.fill"
            }
        }
    }

    weak var finishDelegate: (any CoordinatorFinishDelegate)?

    /// child coordinators
    var childCoordinators: [Tab: any Coordinator] = [:]

    @Published var activeTab = Tab.home

    init() {
        self.childCoordinators[.home] = EmptyCoordinator()
        self.childCoordinators[.diary] = EmptyCoordinator()
        self.childCoordinators[.settings] = EmptyCoordinator()
    }

    deinit {
        print("Deinit TabBarCoordinator")
    }

    let tabConfigs: [TabItemConfig] = Tab.allCases.map {
        .init(tab: $0, title: $0.title, systemImage: $0.systemImage)
    }

    var rootView: some View {
        TabBarView(coordinator: self)
    }

    @MainActor
    @ViewBuilder
    func tabRootView(for tab: Tab) -> some View {
        if let coordinator = self.childCoordinators[tab] {
            AnyView(coordinator.rootView)
        } else {
            AnyView(EmptyView())
        }
    }
}
