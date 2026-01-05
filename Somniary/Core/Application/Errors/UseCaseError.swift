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
enum UseCaseError<ContractError: Error & Equatable, BoundaryError: Error & Equatable>: Error, Equatable {
    /// 유스케이스 계약/규칙
    case contract(ContractError)

    /// 도메인 에러인데 이 유스케이스 계약 밖
    /// "지원하지 않는 상태/정책" 등으로 사용자에게 노출
    case outOfContract(BoundaryError)

    /// 어플리케이션 레벨 에러
    /// 참고: 도메인/유스케이스 흐름에서의 불변식/정합성 위반은
    /// SystemFailure.internalInvariantViolation 동일하게 핸들링하므로
    /// 인프라 계층과 유스케이스를 구분이 필요할 때 분리한다.
    case system(SystemFailure)

    /// INFO: 인프라 계층과 구분이 필요할 때 아래의 케이스 사용을 고려할 것.
    /// 도메인/유스케이스 흐름에서의 불변식/정합성 위반 (사용자에게 노출해야 함)
    /// 주로 앱 코드 수정으로 해결할 수 없는 케이스
    /// 예) 서버 응답 오류, 데이터 정합성 오류
    /// "처리할 수 없습니다" 등으로 사용자에게 노출
//    case invariantViolated(reason: String)
}

extension UseCaseError {
    static func from(
        boundaryError error: BoundaryError,
        classify: (BoundaryError) -> ContractError?
    ) -> Self {
        if let contract = classify(error) {
            // 1. 도메인 계약 안
            return .contract(contract)
        }

        // 2. 도메인 계약 밖
        // - 도메인/유스케이스 불변식 위반은 계약 밖과 동일하게 처리한다.
        // INFO: 시스템이 복잡해질 때 구분할지 고려
        return .outOfContract(error)
    }
}
