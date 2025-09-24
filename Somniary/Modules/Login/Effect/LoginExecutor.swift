//
//  LoginExecutor.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

final class LoginExecutor: EffectExecuting {
    typealias Plan = LoginEffectPlan
    typealias Intent = LoginIntent

    private var tasks: [UUID: Task<Void, Never>] = [:]
    private let dataSource: AuthDataSource

    init(dataSource: AuthDataSource) {
        self.dataSource = dataSource
    }

    func perform(_ plan: Plan, send: @escaping (Intent) -> Void) {
        switch plan.type {
        case let .login(email, otpCode, requestId):
            // 진행 중이면 이전 작업 취소 (Latest wins)
            tasks[requestId]?.cancel()
            tasks[requestId] = Task {
                defer {
                    tasks[requestId] = nil
                }

                let result: Result<Token, LoginError> = await Result.catching {
                    try await dataSource.login(email: email, code: otpCode, idempotencyKey: nil)
                } mapError: {
                    $0 as? LoginError ?? .unknown
                }

                guard !Task.isCancelled else { return }
                await MainActor.run { send(.systemInternal(.loginResponse(result))) }
            }

        case .signup(email: let email, otpCode: let otpCode, requestId: let requestId):
            tasks[requestId]?.cancel()
            tasks[requestId] = Task {
                defer {
                    tasks[requestId] = nil
                }

                let result: Result<Token, LoginError> = await Result.catching {
                    try await dataSource.signup(email: email, code: otpCode, idempotencyKey: nil)
                } mapError: {
                    $0 as? LoginError ?? .unknown
                }

                guard !Task.isCancelled else { return }
                await MainActor.run { send(.systemInternal(.signupResponse(result))) }
            }
        case .logEvent(let message):
            print("[LOG] \(message)")
        default:
            break
        }
    }
}
