//
//  ServicePhase.swift
//  Somniary
//
//  Created by 송태환 on 10/2/25.
//

import Foundation

enum ServicePhase {
    case dev
    case stg
    case prd

    init (string: String?) {
        switch string?.uppercased() {
        case "DEV":
            self = .dev
        case "STAGE":
            self = .stg
        case "PRODUCTION":
            self = .prd
        default:
            fatalError("Unknown service phase")
        }
    }

    var isPrd: Bool {
        return self == .prd
    }

    var isDev: Bool {
        return self == .dev
    }
}
