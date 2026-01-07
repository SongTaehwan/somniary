//
//  RegistrationDomainError+UserMessageKey.swift
//  Somniary
//
//  Created by 송태환 on 1/7/26.
//

import Foundation

extension RegistrationDomainError: UserMessageKeyProviding {
    var userMessageKey: String {
        switch self {
        case .alreadyExists:
            return "registration.error.alreadyExists"
        default:
            return "registration.error.unknown"
        }
    }
}
