//
//  SomniaryButtonStyling.swift
//  Somniary
//
//  Created by 송태환 on 10/8/25.
//

import SwiftUI

protocol SomniaryButtonStyling: ButtonStyle {
    var typographyOverride: Typography? { get }
    var buttonSizeOverride: ButtonSize? { get }
    var isEnabled: Bool { get }

    var defaultTypography: Typography { get }
    var defaultButtonSize: ButtonSize { get }
}
