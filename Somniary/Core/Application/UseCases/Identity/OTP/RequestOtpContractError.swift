//
//  RequestOtpUseCaseError.swift
//  Somniary
//
//  Created by 송태환 on 12/27/25.
//

import Foundation

enum RequestOtpContractError: Error, Equatable {
    // TODO: 이메일 인증 규칙 정의
    case alreadyRegistered
}

typealias RequestOtpUseCaseError = UseCaseError<RequestOtpContractError, IdentityBoundaryError>

extension RequestOtpUseCaseError {
    var userMessage: String {
        ""
    }
}
