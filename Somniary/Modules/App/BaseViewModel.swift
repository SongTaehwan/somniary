//
//  BaseViewModel.swift
//  Somniary
//
//  Created by 송태환 on 12/21/25.
//

import Combine

class BaseViewModel<State: Equatable, Plan: EffectPlan, Intent: Equatable, Route: Routable>: ViewModelType {
    typealias Executor = any EffectExecuting<Plan, Intent>
    typealias Coordinator = any FlowCoordinator<Route>

    @Published var state: State

    /// UI 출력용
    enum OneOffUIEvent {
        case toast(String)
    }

    /// UI 이벤트 전달
    let uiEvent = PassthroughSubject<OneOffUIEvent, Never>()
    let coordinator: Coordinator
    let executor: Executor
    let intents = PassthroughSubject<Intent, Never>()
    var cancellables = Set<AnyCancellable>()

    init(coordinator: Coordinator, executor: Executor, initialState: State) {
        self.coordinator = coordinator
        self.executor = executor
        self.state = initialState
    }

    func send(_ intent: Intent) {
        self.intents.send(intent)
    }
}
