//
//  AppInfoRepresentable.swift
//  Somniary
//
//  Created by 송태환 on 11/5/25.
//

import Foundation
import UIKit

// MARK: Device info
protocol DeviceInfoRepresentable {

    var deviceIdentifier: String { get }
    var deviceType: UIUserInterfaceIdiom { get }
    var osVersion: String { get }
    var isPhone: Bool { get }
    var isPad: Bool { get }
    #if targetEnvironment(simulator)
    var isSimulator: Bool { get }
    #endif
}

// MARK: Metadata
protocol AppMetadataRepresentable {

    var locale: Locale { get }
    var shortVersion: String { get }
    var buildNumber: String { get }
    var version: String { get }
}

// MARK: AppEnvironment Config
protocol AppEnvironmentRepresentable {

    var servicePhase: ServicePhase { get }
    var isDebug: Bool { get }
    var domainServiceURL: String { get }
    var domainClientKey: String { get }
}

protocol AppInfoRepresentable: DeviceInfoRepresentable, AppMetadataRepresentable, AppEnvironmentRepresentable {}
