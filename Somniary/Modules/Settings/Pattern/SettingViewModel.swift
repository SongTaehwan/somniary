//
//  SettingViewModel.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import SwiftUI

final class SettingViewModel: ViewModelType {
    struct State {

    }

    @Published var state = State()

    private let coordinator: any FlowCoordinator<SettingRoute>

    init(coordinator: any FlowCoordinator<SettingRoute>) {
        self.coordinator = coordinator
    }

    func send(_ intent: SettingIntent) {

    }
}
