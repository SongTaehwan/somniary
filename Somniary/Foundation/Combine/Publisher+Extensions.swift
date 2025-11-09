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

extension Publisher where Failure == Never {
    /// CombineLatest 와 동일하나 count 가 1 인 경우 self(이벤트) 쪽 이벤트 방출 시에만 ref 최신값과 함께 구독자에게 전달한다.
    /// 그 외에는 ref 쪽 이벤트 방출도 감지하여 구독자에게 전달됨
    func withLatest<Ref: Publisher>(
        from ref: Ref,
        count: Int = 1
    ) -> AnyPublisher<(Output, Ref.Output), Failure> where Ref.Failure == Failure {
        return self.map { value in
            return ref.map { (value, $0) }
                .prefix(count) // 1인 경우 1번만 방출 및 추가적인 ref 이벤트 무시
                .eraseToAnyPublisher()
        }
        .switchToLatest() // flatten, 이전 구독자 취소
        .eraseToAnyPublisher()
    }

    /// self 쪽 이벤트 방출 시에만 ref 최신값과 함께 구독자에게 전달한다.
    func withLatestOnce<Ref: Publisher>(
        from ref: Ref
    ) -> AnyPublisher<(Output, Ref.Output), Failure> where Ref.Failure == Failure {
        return self.withLatest(from: ref, count: 1)
    }
}

extension Publisher where Output: Equatable, Failure == Never {
    /// 새로 들어오는 이벤트 값과 참조 값이 다른 경우에만 이벤트 값을 전달한다.
    /// self(이벤트)와 ref(참조) 의 최신값을 비교해 "다를 때"만 self의 값을 방출
    func onlyWhenDifferent<Ref: Publisher>(
        from ref: Ref,
    ) -> AnyPublisher<Output, Never> where Ref.Output == Output, Ref.Failure == Failure {
        return self.withLatestOnce(from: ref)
            .filter { input, ref in
                input != ref
            }
            .map { input, ref in
                input
            }
            .eraseToAnyPublisher()
    }
}
