//
//  AppInfo.swift
//  Somniary
//
//  Created by 송태환 on 10/2/25.
//

import Foundation
import UIKit
import os.log

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

/// 디바이스 정보 및 앱 메타데이터
final class AppInfo: AppInfoRepresentable {

    static let shared = AppInfo()

    // TODO: Keychain 이관 고려
    @UserDefault(key: "device_identifier", defaultValue: "")
    var deviceIdentifier: String

    // MARK: Device info
    var deviceType: UIUserInterfaceIdiom {
        return UIDevice.current.userInterfaceIdiom
    }

    // 18.x.x
    var osVersion: String {
        return UIDevice.current.systemVersion
    }

    var isPhone: Bool {
        return self.deviceType == .phone
    }

    var isPad: Bool {
        return self.deviceType == .pad
    }

    #if targetEnvironment(simulator)
    var isSimulator: Bool {
        return true
    }
    #endif

    // MARK: Environment Config
    var servicePhase: ServicePhase {
        guard let phaseString = Bundle.main.object(forInfoDictionaryKey: "SERVICE_PHASE") as? String else {
            return .dev
        }

        return ServicePhase(string: phaseString)
    }

    var domainServiceURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as! String
    }

    var domainClientKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "API_CLIENT_KEY") as! String
    }

    var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }


    // MARK: Metadata
    var locale: Locale {
        return Locale.current
    }

    /// ex) 1.0.3
    var shortVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    /// ex) 123
    var buildNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }

    /// ex) 1.0.3(123)
    var version: String {
        return "\(shortVersion)(\(buildNumber))"
    }

    init() {
        if self.deviceIdentifier.isEmpty {
            self.deviceIdentifier = UUID().uuidString
        }

        #if DEBUG
        self.log()
        #endif
    }

    private func log() {
        let appInfoString = """
        
        APP INFO - first launch: \(AppLaunchChecker.shared.isFirstLaunch)
        APP INFO - device ID: \(deviceIdentifier)
        APP INFO - app version: \(version)
        
        """

        Logger().debug("\(appInfoString)")
    }
}
