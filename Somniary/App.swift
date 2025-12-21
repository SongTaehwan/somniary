//
//  SomniaryApp.swift
//  Somniary
//
//  Created by 송태환 on 9/10/25.
//

import SwiftUI

@main
struct SomniaryApp: App {
    @State private var coordinator = AppContainer.shared.makeAppCoordinator()

    var body: some Scene {
        WindowGroup {
            coordinator.rootView
        }
    }
}
