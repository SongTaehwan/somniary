//
//  UpdateProfileUseCaseError.swift
//  Somniary
//
//  Created by 송태환 on 12/24/25.
//

import Foundation

enum UpdateProfileConractError: Error, Equatable {
    case precondition(PreconditionError)
    // TODO: 도메인 에러 정의
}

typealias UpdateProfileUseCaseError = UseCaseError<UpdateProfileConractError, ProfileBoundaryError>
