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
    private let loginUseCase: LoginUseCase
    private let otpUseCase: RequestOtpUseCase

    init(loginUseCase: LoginUseCase, otpUseCase: RequestOtpUseCase) {
        self.loginUseCase = loginUseCase
        self.otpUseCase = otpUseCase
    }

    func perform(_ plan: Plan, send: @escaping (Intent) -> Void) {
        switch plan.type {
        case let .requestLoginCode(email, requestId):
            // 진행 중이면 이전 작업 취소 (Latest wins)
            tasks[requestId]?.cancel()
            tasks[requestId] = Task {
                defer {
                    tasks[requestId] = nil
                }

                let result = await otpUseCase.execute(.init(email: email))

                guard !Task.isCancelled else { return }
                await MainActor.run { send(.systemInternal(.loginResponse(result))) }
            }

        case let .requestSignupCode(email: email, requestId: requestId):
            tasks[requestId]?.cancel()
            tasks[requestId] = Task {
                defer {
                    tasks[requestId] = nil
                }

                let result = await otpUseCase.execute(.init(email: email))

                guard !Task.isCancelled else { return }
                await MainActor.run { send(.systemInternal(.signupResponse(result))) }
            }
        case let .verify(email: email, otpCode: otpCode, requestId: requestId):
            tasks[requestId]?.cancel()
            tasks[requestId] = Task {
                defer {
                    tasks[requestId] = nil
                }

                let result = await loginUseCase.execute(.init(email: email, otpCode: otpCode))

                guard !Task.isCancelled else { return }
                await MainActor.run { send(.systemInternal(.verifyResponse(result))) }
            }

        case .logEvent(let message):
            print(message)

        case let .authenticateWithApple(credential, requestId):
            tasks[requestId]?.cancel()
            tasks[requestId] = Task {
                defer {
                    tasks[requestId] = nil
                }

                let result = await loginUseCase.execute(credential)

                guard !Task.isCancelled else { return }
                await MainActor.run { send(.systemInternal(.verifyResponse(result))) }
            }
        default:
            break
        }
    }
}
