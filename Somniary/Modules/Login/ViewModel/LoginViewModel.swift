//
//  LoginViewModel.swift
//  Somniary
//
//  Created by 송태환 on 9/11/25.
//

import SwiftUI
import Combine

// TODO: 로그인 422 에러 처리
// TODO: TextField disabled 스타일
// TODO: Loading indicator
// TODO: Apple login
// TODO: Google login
final class LoginViewModel: ViewModelType {

    typealias LoginExecutor = any EffectExecuting<LoginEffectPlan, LoginIntent>

    // MARK: State definition
    struct LoginState: Equatable {
        enum Requirement {
            case email
            case otpCode
            case errorHandling
        }

        var requirement = Requirement.email

        var email: String = ""
        var otpCode: String = ""
        var isLoading = false
        var errorMessage: String?
        /// 멱등, 추적용
        var latestRequestId: UUID?

        var canSubmit: Bool {
            self.otpCodeRequired &&
            self.email.isValidEmail &&
            self.otpCode.count == 6
        }

        var isValidEmail: Bool {
            self.email.isValidEmail
        }

        var otpCodeRequired: Bool {
            self.requirement == .otpCode
        }
    }

    /// UI 출력용
    enum OneOffUIEvent {
        case toast(String)
    }

    // MARK: Published properties
    @Published var state: LoginState = .init()
    @Published var email = ""
    @Published var otpCode = ""

    // MARK: Private properties
    private var cancellables = Set<AnyCancellable>()
    private let intents = PassthroughSubject<LoginIntent, Never>()
    private let executor: LoginExecutor
    private let coordinator: LoginCoordinator
    private let environment: LoginEnvironment

    /// UI 이벤트 전달
    let uiEvent = PassthroughSubject<OneOffUIEvent, Never>()

    // MARK: initializer
    init(
        coordinator: LoginCoordinator,
        environment: LoginEnvironment,
        executor: LoginExecutor
    ) {
        self.coordinator = coordinator
        self.environment = environment
        self.executor = executor
        self.binding()
    }

    deinit {
        print("deinit LoginViewModel")
    }

    /// 사용자 인터렉션 바인딩
    private func binding() {
        self.bindTextFields()
        self.bindButtons()
    }

    /// TextField -> State 로의 단방향 바인딩
    private func bindTextFields() {
        let emailInState = $state.map(\.email)
        $email
            .removeDuplicates()
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .onlyWhenDifferent(from: emailInState)
            .sink { [weak self] in
                self?.send(.user(.emailChanged($0)))
            }
            .store(in: &cancellables)

        // OTP 코드 입력 처리
        let codeInState = $state.map(\.otpCode)
        $otpCode
            .removeDuplicates()
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .onlyWhenDifferent(from: codeInState)
            .sink { [weak self] in
                self?.send(.user(.otpCodeChanged($0)))
            }
            .store(in: &cancellables)
    }

    private func bindButtons() {
        // 로그인 버튼 처리
        let submitLoginTapped = intents.partition {
            $0 == .user(.submitLogin) && self.state.isLoading == false
        }

        submitLoginTapped.included
            .throttle(
                for: .milliseconds(500),
                scheduler: DispatchQueue.main,
                latest: false
            )
            .sink { [weak self] _ in
                self?.handle(.user(.submitLogin))
            }
            .store(in: &cancellables)

        // 회원가입 버튼 처리
        let submitSignupTapped = submitLoginTapped.excluded.partition {
            $0 == .user(.submitSignup) && self.state.isLoading == false
        }

        submitSignupTapped.included
            .throttle(
                for: .milliseconds(500),
                scheduler: DispatchQueue.main,
                latest: false
            )
            .sink { [weak self] _ in
                self?.handle(.user(.submitSignup))
            }
            .store(in: &cancellables)

        // 가입 완료 버튼 처리
        let signupCompletionTapped = submitLoginTapped.excluded.partition { $0 == .user(.signupCompletionTapped) }

        signupCompletionTapped.included
            .throttle(
                for: .milliseconds(500),
                scheduler: DispatchQueue.main,
                latest: false
            )
            .sink { [weak self] _ in
                self?.handle(.user(.signupCompletionTapped))
            }
            .store(in: &cancellables)

        signupCompletionTapped.excluded
            .sink { [weak self] in
                self?.handle($0)
            }
            .store(in: &cancellables)
    }

    private func handle(_ intent: LoginIntent) {
        let (newState, plans) = combinedReducer(state: state, intent: intent, env: environment.reducerEnvironment)
        self.state = newState

        // 네비게이션, UI 출력 관련 output 은 VM 에 위임
        for plan in plans {
            switch plan.type {
            case let .updateTextField(email, otpCode):
                if let email {
                    self.email = email
                }

                if let otpCode {
                    self.otpCode = otpCode
                }

            case .navigateHome:
                self.coordinator.finish()

            case .navigateSignUp:
                self.coordinator.pushToSignUp()

            case .navigateOtpVerification:
                self.coordinator.pushToVerification()

            case .navigateSignupCompletion:
                self.coordinator.pushToCompletion()

            case .showToast(let message):
                self.uiEvent.send(.toast(message))

            default:
                // intent 환류
                executor.perform(plan, send: self.send)
            }
        }
    }

    func send(_ intent: LoginIntent) {
        intents.send(intent)
    }
}
