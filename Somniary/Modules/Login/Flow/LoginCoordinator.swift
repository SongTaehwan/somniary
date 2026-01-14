//
//  LoginCoordinator.swift
//  Somniary
//
//  Created by 송태환 on 9/11/25.
//

import SwiftUI

protocol LoginCoordinatorDependency {
    @MainActor func makeLoginViewModel(_ coordinator: (any FlowCoordinator<LoginRoute>)?) -> LoginViewModel
}

final class LoginCoordinator: FlowCoordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?

    @Published var childCoordinator: (any Coordinator)?
    @Published var childPresentationType: PresentationType?
    @Published var navigationControllers = [NavigationController<LoginRoute>]()

    @MainActor
    private lazy var loginViewModel: LoginViewModel = {
        return self.dependency.makeLoginViewModel(self)
    }()

    private let dependency: LoginCoordinatorDependency

    init(dependency: LoginCoordinatorDependency) {
        self.dependency = dependency
        self.initializeRootNavigationController()
    }

    deinit {
        print("Deinit LoginCoordinator")
    }

    func destination(for route: LoginRoute) -> some View {
        switch route {
        case .main:
            LoginEntryScreen(viewModel: self.loginViewModel)
        case .signup:
            // Signup
            SignUpScreen(viewModel: self.loginViewModel)
        case .completion:
            // completion
            SignUpCompletionScreen(viewModel: self.loginViewModel)
        @unknown default:
            EmptyView()
        }
    }

    var rootView: some View {
        NavigationFlowView(
            coordinator: self,
            navigationController: self.rootNavigationController
        ) {
            LoginEntryScreen(viewModel: self.loginViewModel)
        }
    }
}
