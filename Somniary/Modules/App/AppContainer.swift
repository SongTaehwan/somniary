//
//  AppContainer.swift
//  Somniary
//
//  Created by 송태환 on 12/21/25.
//

import Foundation

final class AppContainer: AppCoordinatorDependency {
    static let shared = AppContainer()

    private let authDataSource = DefaultRemoteAuthDataSource(client: NetworkClientProvider.authNetworkClient)
    private lazy var repository = DefaultRemoteAuthRepository(dataSource: self.authDataSource)

    func makeAppCoordinator() -> AppCoordinator {
        return AppCoordinator(container: self)
    }

    func makeStartFlowCoordinator() -> any Coordinator {
        if TokenRepository.shared.getAccessToken() == nil {
            return self.makeLoginFlowCoordinator()
        }

        let settings = SettingCoordinator(dependency: self)
        let tabBar = TabBarCoordinator(childCoordinators: [
            .home: EmptyCoordinator(),
            .diary: EmptyCoordinator(),
            .settings: settings
        ])

        tabBar.activeTab = .settings

        return tabBar
    }

    func makeDeeplinkCoordinator() -> DeeplinkCoordinator {
        let coordinator = DeeplinkCoordinator()
        coordinator.addHandlers([])
        return coordinator
    }

    func makeLoginFlowCoordinator() -> any Coordinator {
        return LoginCoordinator(dependency: self)
    }
}

// MARK: 로그인 플로우
extension AppContainer: LoginCoordinatorDependency {
    @MainActor func makeLoginViewModel(_ coordinator: (any FlowCoordinator<LoginRoute>)?) -> LoginViewModel {
        let flow = coordinator ?? LoginCoordinator(dependency: self)
        let reducerEnv = LoginReducerEnvironment { UUID() }
        let flowEnv = LoginEnvironment(auth: repository, reducerEnvironment: reducerEnv, crypto: NonceGenerator.shared)
        let executor = LoginExecutor(dataSource: repository, tokenRepository: TokenRepository.shared)
        return LoginViewModel(coordinator: flow, environment: flowEnv, executor: executor)
    }
}

// MARK: 설정 탭 플로우
extension AppContainer: SettingCoordinatorDependency {
    @MainActor func makeSettingViewModel(_ coordinator: (any FlowCoordinator<SettingRoute>)?) -> SettingViewModel {
        let flow = coordinator ?? SettingCoordinator(dependency: self)
        let logoutUsecase = LogoutUseCase(authRepository: self.repository)
        let executor = SettingExecutor(logoutUseCase: logoutUsecase)
        return SettingViewModel(coordinator: flow, executor: executor)
    }
}
