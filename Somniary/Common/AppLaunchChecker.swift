//
//  AppLaunchChecker.swift
//  Somniary
//
//  Created by 송태환 on 9/12/25.
//

import Foundation

struct AppLaunchChecker {
    static let shared = AppLaunchChecker()

    let isFirstLaunch: Bool

    init(storage: UserDefaults = .standard) {
        self.isFirstLaunch = {
            let key = "app.launch.first.key"
            let value = storage.bool(forKey: key)

            if value == false {
                storage.setValue(true, forKey: key)
                return true
            }

            return true
        }()
    }
}
