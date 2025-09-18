//
//  TabBarView.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import SwiftUI

struct TabBarView: View {

    @ObservedObject var coordinator: TabBarCoordinator

    var body: some View {
        if #available(iOS 18.0, *) {
            TabView(selection: $coordinator.activeTab) {
                ForEach(coordinator.tabConfigs) { config in
                    Tab(
                        config.title,
                        systemImage: config.systemImage,
                        value: config.tab
                    ) {
                        coordinator.tabRootView(for: config.tab)
                            .tag(config.tab)
                    }
                }
            }
        } else {
            TabView(selection: $coordinator.activeTab) {
                ForEach(coordinator.tabConfigs) { config in
                    coordinator.tabRootView(for: config.tab)
                        .tabItem {
                            Label(config.title, systemImage: config.systemImage)
                        }
                        .tag(config.tab)
                }
            }
        }
    }
}

#Preview {
    TabBarView(coordinator: .init())
}
