//
//  Optional+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 10/2/25.
//

import Foundation

extension Optional: AnyOptional {
    var isNil: Bool {
        return self == nil
    }
}
