//
//  AppContainer.swift
//  Somniary
//
//  Created by 송태환 on 12/21/25.
//

import Foundation

final class AppContainer: AppCoordinatorDependency {
    static let shared = AppContainer()

    private let authDataSource: DefaultRemoteAuthDataSource

    init() {
        self.authDataSource = DefaultRemoteAuthDataSource(client: NetworkClientProvider.authNetworkClient)
    }

    func makeAppCoordinator() -> AppCoordinator {
        return AppCoordinator(
            container: self
        )
    }

    func makeStartFlowCoodinator() -> any Coordinator {
        if AppLaunchChecker.shared.isFirstLaunch || TokenRepository.shared.getAccessToken() == nil {
            return LoginCoordinator(dependency: self)
        }

        return TabBarCoordinator()
    }

    func makeDeeplinkCoordinator() -> DeeplinkCoordinator {
        let coordinator = DeeplinkCoordinator()
        coordinator.addHandlers([])
        return coordinator
    }
}

// MARK: 로그인 플로우
extension AppContainer: LoginCoordinatorDependency {
    func makeLoginFlowCoordinator() -> LoginCoordinator {
        return LoginCoordinator(dependency: self)
    }

    @MainActor func makeLoginViewModel(_ coordinator: (any FlowCoordinator<LoginRoute>)?) -> LoginViewModel {
        let flow = coordinator ?? LoginCoordinator(dependency: self)
        let repository = DefaultRemoteAuthRepository(dataSource: self.authDataSource)
        let reducerEnv = LoginReducerEnvironment { UUID() }
        let flowEnv = LoginEnvironment(auth: repository, reducerEnvironment: reducerEnv, crypto: NonceGenerator.shared)
        let executor = LoginExecutor(dataSource: repository, tokenRepository: TokenRepository.shared)
        return LoginViewModel(coordinator: flow, environment: flowEnv, executor: executor)
    }
}

// MARK: 설정 탭 플로우

