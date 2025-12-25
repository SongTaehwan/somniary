//
//  UseCaseError.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//

import Foundation

/// 유스케이스가 외부로 노출하는 실패를 domain(계약), application, unexpected(계약 밖/불변식)로 구성해 반환하는 에러
/// ContractError - 해당 유스케이스 계약 내에서 처리할 에러
/// FailureCause - ContractError 을 포함하는 도메인 에러의 집합. 계약 밖 에러도 포함
enum UseCaseError<ContractError: Error & Equatable, FailureCause: Error & Equatable>: Error, Equatable {
    /// 유스케이스 계약/규칙
    case domain(ContractError)
    /// 어플리케이션 레벨 에러
    case application(ApplicationError)
    /// 유스케이스 계약 밖이거나 불변식 위반 에러
    case unexpected(UnexpectedFailure<FailureCause>)
}

extension UseCaseError {
    enum Classification {
        // 도메인 계약 안
        case contract(ContractError)
        // 도메인 계약 밖
        case outOfContract
        // 도메인 불변식 위반
        case invariant(resaon: String)
    }

    static func from(
        failureCause error: FailureCause,
        classify: (FailureCause) -> Classification
    ) -> Self {
        switch classify(error) {
        case .contract(let contract):
            // 1. 도메인 계약 안
            return  .domain(contract)
        case .outOfContract:
            // 2. 도메인 계약 밖
            return .unexpected(.domain(error))
        case .invariant(let resaon):
            // 3. 도메인 불변식 위반
            return .unexpected(.invariantViolated(reason: resaon))
        }
    }
}
