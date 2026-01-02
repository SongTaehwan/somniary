//
//  ProfileDomainError.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//

import Foundation

enum ProfileDomainError: Error, Equatable {
    case invalidNickname(reason: String)
}
