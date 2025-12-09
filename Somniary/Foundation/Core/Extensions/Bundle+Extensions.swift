//
//  Bundle+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

extension Bundle {
    var currentVersion: String? {
        return self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
