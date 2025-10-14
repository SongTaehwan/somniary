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
    private let authRepository: AuthReposable
    private let tokenRepository: TokenReposable

    init(dataSource: AuthReposable, tokenRepository: TokenReposable) {
        self.authRepository = dataSource
        self.tokenRepository = tokenRepository
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

                let result: Result<VoidResponse, LoginError> = await Result.catching {
                    try await authRepository.requestOtpCode(email: email, createUser: false, idempotencyKey: nil)
                } mapError: {
                    $0 as? LoginError ?? .unknown
                }

                guard !Task.isCancelled else { return }
                await MainActor.run { send(.systemInternal(.loginResponse(result))) }
            }

        case let .requestSignupCode(email: email, requestId: requestId):
            tasks[requestId]?.cancel()
            tasks[requestId] = Task {
                defer {
                    tasks[requestId] = nil
                }

                let result: Result<VoidResponse, LoginError> = await Result.catching {
                    try await authRepository.requestOtpCode(email: email, createUser: true, idempotencyKey: nil)
                } mapError: {
                    $0 as? LoginError ?? .unknown
                }

                guard !Task.isCancelled else { return }
                await MainActor.run { send(.systemInternal(.signupResponse(result))) }
            }
        case let .verify(email: email, otpCode: otpCode, requestId: requestId):
            tasks[requestId]?.cancel()
            tasks[requestId] = Task {
                defer {
                    tasks[requestId] = nil
                }

                let result: Result<TokenEntity, LoginError> = await Result.catching {
                    try await authRepository.verify(email: email, otpCode: otpCode, idempotencyKey: nil)
                } mapError: {
                    $0 as? LoginError ?? .unknown
                }

                guard !Task.isCancelled else { return }
                await MainActor.run { send(.systemInternal(.verifyResponse(result))) }
            }

        case .logEvent(let message):
            print(message)

        case .storeToken(let token):
            self.tokenRepository.updateToken(.init(accessToken: token.accessToken, refreshToken: token.refreshToken))

        case let .authenticateWithApple(credential, requestId):
            tasks[requestId]?.cancel()
            tasks[requestId] = Task {
                defer {
                    tasks[requestId] = nil
                }

                let result: Result<TokenEntity, LoginError> = await Result.catching {
                    try await authRepository.verify(credential: credential, idempotencyKey: nil)
                } mapError: {
                    $0 as? LoginError ?? .unknown
                }

                guard !Task.isCancelled else { return }
                await MainActor.run { send(.systemInternal(.verifyResponse(result))) }
            }
        default:
            break
        }
    }
}
