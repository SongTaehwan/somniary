//
//  AppLaunchChecker.swift
//  Somniary
//
//  Created by 송태환 on 9/12/25.
//

import Foundation

protocol AppLaunchChecking {
    var isFirstLaunch: Bool { get }
}

struct AppLaunchChecker: AppLaunchChecking {
    
    static let shared = AppLaunchChecker()
    
    let isFirstLaunch: Bool
    
    private static let defaultKey = "app.launch.first.key"

    init(storage: UserDefaults = .standard, key: String = AppLaunchChecker.defaultKey) {
        self.isFirstLaunch = {
            let value = storage.value(forKey: key) as? Bool

            if value == nil {
                storage.setValue(false, forKey: key)
                return true
            }

            return value ?? false
        }()
    }
}
