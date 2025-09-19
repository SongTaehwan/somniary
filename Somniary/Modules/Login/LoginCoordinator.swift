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
        return LoginViewModel(coordinator: self)
    }()

    init() {
        self.initializeRootNavigationController()
    }

    deinit {
        print("Deinit LoginCoordinator")
    }

    func destination(for route: LoginRoute) -> some View {
        switch route {
        case .login:
            EmptyView()
        case .signup:
            // Signup
            EmptyView()
        case .verification:
            // SignupVerification
            EmptyView()
        case .completion:
            // completion
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }

    var rootView: some View {
        NavigationFlowView(
            coordinator: self,
            navigationController: self.rootNavigationController
        ) {
            EmptyView()
        }
    }

    func navigateToHome() {
        self.finish()
    }

    func pushToSignIn() {
        self.push(route: .login)
    }

    func pushToSignUp() {
        self.push(route: .signup)
    }

    func pushToVerification() {
        self.push(route: .verification)
    }
}
