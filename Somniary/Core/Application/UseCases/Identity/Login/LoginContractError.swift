//
//  LoginContractError.swift
//  Somniary
//
//  Created by 송태환 on 1/2/26.
//

import Foundation

enum LoginContractError: Error, Equatable {
    // TODO: 이메일 로그인 규칙 정의
    case invalidPassword
}

typealias LoginUseCaseError = UseCaseError<LoginContractError, IdentityBoundaryError>
