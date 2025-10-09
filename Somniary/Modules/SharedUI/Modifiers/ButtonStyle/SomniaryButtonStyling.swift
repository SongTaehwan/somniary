//
//  SomniaryButtonStyling.swift
//  Somniary
//
//  Created by 송태환 on 10/8/25.
//

import SwiftUI

protocol SomniaryButtonStyling: ButtonStyle {
    associatedtype StyleConfig
    
    var isEnabled: Bool { get }
    var typographyOverride: Typography? { get }
    var buttonSizeOverride: ButtonSize? { get }
    var styleConfigOverride: StyleConfig? { get }
}
