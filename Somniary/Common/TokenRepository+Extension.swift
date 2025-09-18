//
//  Singleton.swift
//  Somniary
//
//  Created by 송태환 on 9/17/25.
//

import Foundation

extension TokenRepository {
    static let shared = TokenRepository(storage: KeychainStorage(), appLaunchChecker: AppLaunchChecker.shared)
}
