//
//  AppContainer.swift
//  Somniary
//
//  Created by 송태환 on 12/21/25.
//

import Foundation

final class AppContainer: AppCoordinatorDependency {
    static let shared = AppContainer()

    // Data Source
    private let authDataSource = DefaultRemoteAuthDataSource(client: NetworkClientProvider.authNetworkClient)
    private let profileRemoteDataSource = DefaultProfileRemoteDataSource(client: NetworkClientProvider.userNetworkClient)

    // Repository
    private lazy var profileRepository = DefaultRemoteProfileRepository(remote: self.profileRemoteDataSource, local: DefaultProfileLocalDataSource())

    // usecase
    private lazy var getProfileUseCase = GetProfileUseCase(repository: self.profileRepository)


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
        let authRepository = DefaultRemoteAuthRepository(dataSource: self.authDataSource)
        let flowEnv = LoginEnvironment(auth: authRepository, reducerEnvironment: reducerEnv, crypto: NonceGenerator.shared)
        let executor = LoginExecutor(loginUseCase: .init(repository: authRepository), emailUseCase: .init(repository: authRepository))
        return LoginViewModel(coordinator: flow, environment: flowEnv, executor: executor)
    }
}

// MARK: 설정 탭 플로우
extension AppContainer: SettingCoordinatorDependency {
    @MainActor func makeSettingViewModel(_ coordinator: (any FlowCoordinator<SettingRoute>)?) -> SettingViewModel {
        let flow = coordinator ?? SettingCoordinator(dependency: self)
        let authRepository = DefaultRemoteAuthRepository(dataSource: self.authDataSource)
        let logoutUsecase = LogoutUseCase(authRepository: authRepository)

        let executor = SettingExecutor(
            logoutUseCase: logoutUsecase,
            getProfileUseCase: getProfileUseCase,
            updateProfileUseCase: UpdateProfileUseCase(repository: self.profileRepository)
        )
        return SettingViewModel(coordinator: flow, executor: executor)
    }
}
