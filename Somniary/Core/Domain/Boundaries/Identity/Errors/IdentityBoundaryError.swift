//
//  IdentityBoundaryError.swift
//  Somniary
//
//  Created by 송태환 on 1/3/26.
//


import Foundation

enum IdentityBoundaryError: Error, Equatable {
    case auth(AuthDomainError)
    case registration(RegistrationDomainError)
}
