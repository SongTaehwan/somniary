//
//  RegistrationDomainError.swift
//  Somniary
//
//  Created by 송태환 on 12/27/25.
//

import Foundation

enum RegistrationDomainError: Error, Equatable {
    /// 회원 존재
    case alreadyExists(reason: AlreadyExistsReason)

    enum AlreadyExistsReason: Error, Equatable {
        case duplicatedEmail
    }
}
