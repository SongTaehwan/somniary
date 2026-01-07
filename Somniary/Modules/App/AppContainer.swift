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
    @MainActor
    func makeLoginViewModel(_ coordinator: (any FlowCoordinator<LoginRoute>)?) -> LoginViewModel {
        let flow = coordinator ?? LoginCoordinator(dependency: self)

        // LoginUseCase 에러 메시지
        // 케이스를 추가해 에러 메시지 및 액션 변경
        // resolver 재사용 또는 feature 별 커스텀 가능
        let loginErrorMessageOverride = TypedPartialUseCaseResolutionResolver<LoginContractError, IdentityBoundaryError>(resolveTyped: { error in
            switch error {
            case .contract(.invalidPassword):
                return .inform(message: "login.error.invalid_password")
            case .outOfContract(.auth(.authRequired(reason: .accessTokenExpired))):
                return .reauth(mode: .normal, message: "auth.error.expired")
            default:
                // UserMessageKeyProviding 또는 fallback 키를 메시지로 사용
                // UseCaseResolution 구현체 참고
                return nil
            }
        })

        // RequestOtpUseCase 에러 메시지
        let otpErrorMessageOverride = TypedPartialUseCaseResolutionResolver<RequestOtpContractError, IdentityBoundaryError> { error in
            switch error {
            case .contract(.alreadyRegistered):
                return .inform(message: "register.error.already_registered")
            default:
                return nil
            }
        }

        let reducerEnv = LoginReducerEnvironment(useCaseResolutionResolver: ChainedUseCaseResolutionResolver(partials: [loginErrorMessageOverride, otpErrorMessageOverride])) {
            UUID()
        }

        let authRepository = DefaultRemoteAuthRepository(dataSource: self.authDataSource)
        let flowEnv = LoginEnvironment(auth: authRepository, reducerEnvironment: reducerEnv, crypto: NonceGenerator.shared)
        let executor = LoginExecutor(loginUseCase: .init(repository: authRepository), otpUseCase: .init(repository: authRepository))
        return LoginViewModel(coordinator: flow, environment: flowEnv, executor: executor)
    }
}

// MARK: 설정 탭 플로우
extension AppContainer: SettingCoordinatorDependency {
    @MainActor
    func makeSettingViewModel(_ coordinator: (any FlowCoordinator<SettingRoute>)?) -> SettingViewModel {
        let flow = coordinator ?? SettingCoordinator(dependency: self)
        let authRepository = DefaultRemoteAuthRepository(dataSource: self.authDataSource)
        let logoutUsecase = LogoutUseCase(authRepository: authRepository)

        let reducerEnv = SettingReducerEnvironment(useCaseResolutionResolver: ChainedUseCaseResolutionResolver(partials: [])) {
            UUID()
        }

        let executor = SettingExecutor(
            logoutUseCase: logoutUsecase,
            getProfileUseCase: getProfileUseCase,
            updateProfileUseCase: UpdateProfileUseCase(repository: self.profileRepository)
        )

        let environment = SettingEnvironment(reducerEnv: reducerEnv)
        return SettingViewModel(coordinator: flow, executor: executor, environment: environment)
    }
}
