//
//  Publisher+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Combine

extension Publisher {
    func partition(by isIncluded: @escaping (Output) -> Bool) -> (included: AnyPublisher<Output, Failure>, excluded: AnyPublisher<Output, Failure>) {
        let shared = self.share()
        let included = shared.filter(isIncluded)
        let excluded = shared.filter { !isIncluded($0) }
        return (included.eraseToAnyPublisher(), excluded.eraseToAnyPublisher())
    }
}
