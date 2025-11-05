//
//  AnyOptional.swift
//  Somniary
//
//  Created by 송태환 on 10/2/25.
//

import Foundation

protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool {
        return self == nil
    }
}
