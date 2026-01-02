//
//  EmailVerificationUseCaseError.swift
//  Somniary
//
//  Created by 송태환 on 12/27/25.
//

import Foundation

enum EmailVerificationContractError: Error, Equatable {
    // TODO: 이메일 인증 규칙 정의
    case alreadyRegistered
}

typealias EmailVerificationUseCaseError = UseCaseError<EmailVerificationContractError, IdentityBoundaryError>

extension EmailVerificationUseCaseError {
    var userMessage: String {
        ""
    }
}
