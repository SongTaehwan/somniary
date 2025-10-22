//
//  LoginViewModel.swift
//  Somniary
//
//  Created by 송태환 on 9/11/25.
//

import SwiftUI
import Combine
import AuthenticationServices

// TODO: 로그인 422 에러 처리
// TODO: Loading indicator 정책 정의
final class LoginViewModel: ViewModelType {

    typealias LoginExecutor = any EffectExecuting<LoginEffectPlan, LoginIntent>

    // MARK: State definition
    struct LoginState: Equatable, Copyable {
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

        var appleNonce: String?

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

// MARK: 플랫폼 관련 메서드
extension LoginViewModel {
    
    func configureAppleSignInRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = environment.crypto.generateSecureRandom(length: 32)

        // 비즈니스 로직에 따른 스코프 결정
        request.requestedScopes = [.email, .fullName]
        request.nonce = environment.crypto.sha256(nonce)

        // 테스트 검증 및 추적용
        self.state.appleNonce = nonce
        // 로딩 인디케이터 표시 및 로그 출력
        self.send(.systemExtenral(.appleLoginRequest))
    }

    /// 애플 로그인 결과를 매핑하여 LoginIntent 방출
    /// - Note: View → ViewModel 경계에서 플랫폼 타입 수용
    func handleAppleSignInCompletion(_ result: Result<ASAuthorization, Error>) {
        guard let nonce = self.state.appleNonce else {
           // Nonce가 없으면 에러로 처리
            let error = AppleLoginError.missingNonce()
           self.send(.systemExtenral(.appleLoginCompleted(.failure(error))))
           return
       }

        // ViewModel 내부에서 도메인 타입으로 변환
        let domainResult = result
            .mapError { AppleLoginError.from($0) }
            .flatMap { authorization in
                AppleSignInMapper.toCredential(authorization, expectedNonce: nonce)
            }

        self.state.appleNonce = nil

        // 도메인 Intent 발행
        self.send(.systemExtenral(.appleLoginCompleted(domainResult)))
    }

    // TODO: Google login
}
