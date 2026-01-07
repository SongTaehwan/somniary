//
//  UseCaseResolutionResolver.swift
//  Somniary
//
//  Created by 송태환 on 1/7/26.
//

import Foundation

// MARK: UseCase 에러 메시지에 대한 커스텀 Resolver
struct TypedPartialUseCaseResolutionResolver<C: Error & Equatable, B: Error & Equatable>: PartialUseCaseResolutionResolving {
    private let resolveTyped: (UseCaseError<C, B>) -> UseCaseResolution?

    init(resolveTyped: @escaping (UseCaseError<C, B>) -> UseCaseResolution?) {
        self.resolveTyped = resolveTyped
    }

    func tryResolve<Contract: Error & Equatable, Boundary: Error & Equatable>(
        _ error: UseCaseError<Contract, Boundary>
    ) -> UseCaseResolution? {
        guard let typed = error as? UseCaseError<C, B> else {
            return nil
        }

        return resolveTyped(typed)
    }
}

// MARK: 커스텀 Resolver 체인
struct ChainedUseCaseResolutionResolver: UseCaseResolutionResolving {
    private let partials: [any PartialUseCaseResolutionResolving]

    init(partials: [any PartialUseCaseResolutionResolving]) {
        self.partials = partials
    }

    func resolve<Contract: Error & Equatable, Boundary: Error & Equatable>(
        _ error: UseCaseError<Contract, Boundary>
    ) -> UseCaseResolution {
        for partial in partials {
            if let resolution = partial.tryResolve(error) {
                return resolution
            }
        }

        return UseCaseResolution.resolve(error) // 공통 기본 정책
    }
}
