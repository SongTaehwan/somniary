//
//  LoginCoordinator.swift
//  Somniary
//
//  Created by 송태환 on 9/11/25.
//

import SwiftUI

final class LoginCoordinator: FlowCoordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?

    @Published var childCoordinator: (any Coordinator)?
    @Published var childPresentationType: PresentationType?
    @Published var navigationControllers = [NavigationController<LoginRoute>]()

    @MainActor
    private lazy var loginViewModel: LoginViewModel = {
        let dataSource = RemoteAuthRepository(client: NetworkClientProvider.authNetworkClient)
        let reducerEnv = LoginReducerEnvironment { UUID() }
        let flowEnv = LoginEnvironment(auth: dataSource, reducerEnvironment: reducerEnv)
        let executor = LoginExecutor(dataSource: dataSource)
        return LoginViewModel(coordinator: self, environment: flowEnv, executor: executor)
    }()

    init() {
        self.initializeRootNavigationController()
    }

    deinit {
        print("Deinit LoginCoordinator")
    }

    func destination(for route: LoginRoute) -> some View {
        switch route {
        case .main:
            LoginView(viewModel: self.loginViewModel)
        case .signup:
            // Signup
            SignUpView(viewModel: self.loginViewModel)
        case .verification:
            // SignupVerification
            LoginVerificationView(viewModel: self.loginViewModel)
        case .completion:
            // completion
            SignUpCompletionView(viewModel: self.loginViewModel)
        @unknown default:
            EmptyView()
        }
    }

    var rootView: some View {
        NavigationFlowView(
            coordinator: self,
            navigationController: self.rootNavigationController
        ) {
            LoginView(viewModel: self.loginViewModel)
        }
    }

    func navigateToHome() {
        self.finish()
    }

    func pushToSignIn() {
        self.push(route: .main)
    }

    func pushToSignUp() {
        self.push(route: .signup)
    }

    func pushToVerification() {
        self.push(route: .verification)
    }

    func pushToCompletion() {
        self.push(route: .completion)
    }
}
