//
//  GetProfileContractError.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//

import Foundation

/// 유스케이스에서 발생할 수 있는 도메인 에러
/// - 유스케이스 계약으로 정의된 에러
enum GetProfileContractError: Error, Equatable {
    case precondition(PreconditionError)
    // TODO: 도메인 에러 정의
    case invalidNickname
}

typealias GetProfileUseCaseError = UseCaseError<GetProfileContractError, ProfileBoundaryError>
