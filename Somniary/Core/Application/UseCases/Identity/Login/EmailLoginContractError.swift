//
//  EmailLoginUseCaseError.swift
//  Somniary
//
//  Created by 송태환 on 1/2/26.
//

import Foundation

enum EmailLoginContractError: Error, Equatable {
    // TODO: 이메일 로그인 규칙 정의
    var userMessage: String {
        ""
    }
}

typealias EmailLoginUseCaseError = UseCaseError<EmailLoginContractError, IdentityBoundaryError>

extension EmailLoginUseCaseError {
    var userMessage: String {
        ""
    }
}
