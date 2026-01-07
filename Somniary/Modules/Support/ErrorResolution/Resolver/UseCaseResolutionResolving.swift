//
//  UseCaseResolutionResolving.swift
//  Somniary
//
//  Created by 송태환 on 1/5/26.
//

import Foundation

/// UseCaseResolution 로 매핑된 UseCaseError 메시지 중 기능/상황에 따라 다른 메시지나 액션을 제공해야하는 경우
/// 커스텀 메시지/액션을 PartialUseCaseResolutionResolving 를 통해 정의하고 UseCaseResolutionResolving 를 통해 소비
/// Resolver 재사용 또는 feature 별 커스텀 가능
protocol UseCaseResolutionResolving {
    func resolve<Contract: Error & Equatable, Boundary: Error & Equatable>(
        _ error: UseCaseError<Contract, Boundary>
    ) -> UseCaseResolution
}

protocol PartialUseCaseResolutionResolving {
    func tryResolve<Contract: Error & Equatable, Boundary: Error & Equatable>(
        _ error: UseCaseError<Contract, Boundary>
    ) -> UseCaseResolution?
}
