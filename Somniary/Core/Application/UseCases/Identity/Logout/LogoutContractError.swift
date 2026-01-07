//
//  LogoutContractError.swift
//  Somniary
//
//  Created by 송태환 on 1/7/26.
//

import Foundation

enum LogoutContractError: Error, Equatable {

}

typealias LogoutUseCaseError = UseCaseError<LogoutContractError, IdentityBoundaryError>
