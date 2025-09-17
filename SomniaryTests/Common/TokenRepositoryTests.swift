//
//  TokenRepositoryTests.swift
//  SomniaryTests
//
//  Created by 송태환 on 9/17/25.
//

import XCTest
@testable import Somniary

final class TokenRepositoryTests: XCTestCase {

    // MARK: - Test Fixtures

    private var tokenRepository: TokenRepository!
    private var mockStorage: MockTokenStorage!
    private var mockAppLaunchChecker: MockAppLaunchChecker!

    // MARK: - Mock Objects

    /// 테스트용 토큰 저장소 모의 객체
    final class MockTokenStorage: KeyStoring {
        typealias ValueKey = TokenStorageKey
        
        private var storage: [TokenStorageKey: Any] = [:]
        private let queue = DispatchQueue(label: "mock.storage", attributes: .concurrent)
        
        // 동기 저장으로 테스트 안정성 보장
        func save<T: Codable>(_ value: T, for key: TokenStorageKey) throws {
            queue.sync(flags: .barrier) { [weak self] in
                self?.storage[key] = value
            }
        }
        
        func retrieve<T: Decodable>(for key: TokenStorageKey) -> T? {
            return queue.sync {
                return storage[key] as? T
            }
        }
        
        // 동기 삭제로 테스트 안정성 보장
        func clear(keys: [TokenStorageKey]) {
            queue.sync(flags: .barrier) { [weak self] in
                keys.forEach { key in
                    self?.storage.removeValue(forKey: key)
                }
            }
        }
        
        func clear(key: TokenStorageKey) {
            clear(keys: [key])
        }
        
        // 테스트 검증용 헬퍼 메서드
        func isStorageEmpty() -> Bool {
            return queue.sync { 
                storage.isEmpty 
            }
        }
        
        func hasToken() -> Bool {
            return queue.sync { 
                storage[.tokenPair] != nil 
            }
        }
    }

    /// 테스트용 앱 런치 체커 모의 객체
    final class MockAppLaunchChecker: AppLaunchChecking {
        var isFirstLaunch: Bool

        init(isFirstLaunch: Bool = false) {
            self.isFirstLaunch = isFirstLaunch
        }
    }

    // MARK: - Setup & Teardown

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockStorage = MockTokenStorage()
        mockAppLaunchChecker = MockAppLaunchChecker()
        tokenRepository = TokenRepository(
            storage: mockStorage,
            appLaunchChecker: mockAppLaunchChecker
        )
    }

    override func tearDownWithError() throws {
        tokenRepository = nil
        mockStorage = nil
        mockAppLaunchChecker = nil
        try super.tearDownWithError()
    }

    // MARK: - 초기화 테스트

    func test_init_첫_실행_시_토큰을_복원하지_않는다() throws {
        // Given: 첫 실행 상황과 저장된 토큰
        let existingToken = TokenEntity(accessToken: "existing_access", refreshToken: "existing_refresh")
        try mockStorage.save(existingToken, for: .tokenPair)

        let firstLaunchChecker = MockAppLaunchChecker(isFirstLaunch: true)

        // When: 첫 실행으로 TokenRepository 초기화
        let repository = TokenRepository(storage: mockStorage, appLaunchChecker: firstLaunchChecker)

        // Then: 토큰이 복원되지 않아야 함
        XCTAssertNil(repository.getAccessToken(), "첫 실행 시 토큰이 복원되지 않아야 합니다.")
        XCTAssertNil(repository.getRefreshToken(), "첫 실행 시 토큰이 복원되지 않아야 합니다.")
    }

    func test_init_재실행_시_저장된_토큰을_복원한다() throws {
        // Given: 재실행 상황과 저장된 토큰 (동기 저장으로 즉시 완료)
        let existingToken = TokenEntity(accessToken: "stored_access", refreshToken: "stored_refresh")
        try mockStorage.save(existingToken, for: .tokenPair)

        let notFirstLaunchChecker = MockAppLaunchChecker(isFirstLaunch: false)

        // When: 재실행으로 TokenRepository 초기화
        let repository = TokenRepository(storage: mockStorage, appLaunchChecker: notFirstLaunchChecker)

        // 복원 작업 완료 대기 (폴링 방식으로 안정성 보장)
        let expectation = XCTestExpectation(description: "토큰 복원 완료")
        
        func checkRestoration() {
            if repository.getAccessToken() != nil && repository.getRefreshToken() != nil {
                expectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.05) {
                    checkRestoration()
                }
            }
        }
        
        checkRestoration()
        wait(for: [expectation], timeout: 2.0)

        // Then: 저장된 토큰이 복원되어야 함
        XCTAssertEqual(repository.getAccessToken(), "stored_access", "저장된 액세스 토큰이 복원되지 않았습니다.")
        XCTAssertEqual(repository.getRefreshToken(), "stored_refresh", "저장된 리프레시 토큰이 복원되지 않았습니다.")
    }

    func test_init_재실행이지만_저장된_토큰이_없으면_복원하지_않는다() {
        // Given: 재실행 상황이지만 저장된 토큰 없음
        let notFirstLaunchChecker = MockAppLaunchChecker(isFirstLaunch: false)

        // When: 빈 저장소로 TokenRepository 초기화
        let repository = TokenRepository(storage: mockStorage, appLaunchChecker: notFirstLaunchChecker)

        // Then: 토큰이 없어야 함
        XCTAssertNil(repository.getAccessToken(), "저장된 토큰이 없으면 복원하지 않아야 합니다.")
        XCTAssertNil(repository.getRefreshToken(), "저장된 토큰이 없으면 복원하지 않아야 합니다.")
    }

    // MARK: - 토큰 업데이트 테스트

    func test_updateToken_토큰을_성공적으로_업데이트한다() throws {
        // Given: 새로운 토큰
        let newToken = TokenEntity(accessToken: "new_access_token", refreshToken: "new_refresh_token")

        // When: 토큰 업데이트
        tokenRepository.updateToken(newToken)

        // 업데이트 완료 대기 (폴링 방식으로 안정성 보장)
        let expectation = XCTestExpectation(description: "토큰 업데이트 완료")
        
        func checkUpdate() {
            if tokenRepository.getAccessToken() == "new_access_token" && 
               tokenRepository.getRefreshToken() == "new_refresh_token" &&
               mockStorage.hasToken() {
                expectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.05) {
                    checkUpdate()
                }
            }
        }
        
        checkUpdate()
        wait(for: [expectation], timeout: 2.0)

        // Then: 메모리와 저장소 모두에 토큰이 저장되어야 함
        XCTAssertEqual(tokenRepository.getAccessToken(), "new_access_token", "액세스 토큰이 업데이트되지 않았습니다.")
        XCTAssertEqual(tokenRepository.getRefreshToken(), "new_refresh_token", "리프레시 토큰이 업데이트되지 않았습니다.")
        XCTAssertTrue(mockStorage.hasToken(), "저장소에 토큰이 저장되지 않았습니다.")
    }

    func test_updateToken_기존_토큰을_덮어쓴다() throws {
        // Given: 기존 토큰 저장
        let oldToken = TokenEntity(accessToken: "old_access", refreshToken: "old_refresh")
        tokenRepository.updateToken(oldToken)

        // 첫 번째 업데이트 완료 대기
        let firstExpectation = XCTestExpectation(description: "첫 번째 업데이트 완료")
        
        func checkFirstUpdate() {
            if tokenRepository.getAccessToken() == "old_access" {
                firstExpectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.05) {
                    checkFirstUpdate()
                }
            }
        }
        
        checkFirstUpdate()
        wait(for: [firstExpectation], timeout: 2.0)

        // When: 새로운 토큰으로 업데이트
        let newToken = TokenEntity(accessToken: "updated_access", refreshToken: "updated_refresh")
        tokenRepository.updateToken(newToken)

        // 두 번째 업데이트 완료 대기
        let secondExpectation = XCTestExpectation(description: "두 번째 업데이트 완료")
        
        func checkSecondUpdate() {
            if tokenRepository.getAccessToken() == "updated_access" &&
               tokenRepository.getRefreshToken() == "updated_refresh" {
                secondExpectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.05) {
                    checkSecondUpdate()
                }
            }
        }
        
        checkSecondUpdate()
        wait(for: [secondExpectation], timeout: 2.0)

        // Then: 새로운 토큰으로 덮어써져야 함
        XCTAssertEqual(tokenRepository.getAccessToken(), "updated_access", "기존 토큰이 덮어써지지 않았습니다.")
        XCTAssertEqual(tokenRepository.getRefreshToken(), "updated_refresh", "기존 토큰이 덮어써지지 않았습니다.")
    }

    // MARK: - 토큰 조회 테스트

    func test_getAccessToken_저장된_토큰이_없으면_nil을_반환한다() {
        // Given: 빈 상태의 repository

        // When: 액세스 토큰 조회
        let accessToken = tokenRepository.getAccessToken()

        // Then: nil을 반환해야 함
        XCTAssertNil(accessToken, "저장된 토큰이 없으면 nil을 반환해야 합니다.")
    }

    func test_getRefreshToken_저장된_토큰이_없으면_nil을_반환한다() {
        // Given: 빈 상태의 repository

        // When: 리프레시 토큰 조회
        let refreshToken = tokenRepository.getRefreshToken()

        // Then: nil을 반환해야 함
        XCTAssertNil(refreshToken, "저장된 토큰이 없으면 nil을 반환해야 합니다.")
    }

    // MARK: - 토큰 삭제 테스트

    func test_clear_토큰을_성공적으로_삭제한다() throws {
        // Given: 저장된 토큰
        let token = TokenEntity(accessToken: "test_access", refreshToken: "test_refresh")
        tokenRepository.updateToken(token)

        // 업데이트 완료 대기
        let updateExpectation = XCTestExpectation(description: "토큰 저장 완료")
        
        func checkTokenSaved() {
            if tokenRepository.getAccessToken() == "test_access" {
                updateExpectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.05) {
                    checkTokenSaved()
                }
            }
        }
        
        checkTokenSaved()
        wait(for: [updateExpectation], timeout: 2.0)

        // When: 토큰 삭제
        tokenRepository.clear()

        // 삭제 작업 완료 대기
        let clearExpectation = XCTestExpectation(description: "토큰 삭제 완료")
        
        func checkTokenCleared() {
            if tokenRepository.getAccessToken() == nil && 
               tokenRepository.getRefreshToken() == nil &&
               !mockStorage.hasToken() {
                clearExpectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.05) {
                    checkTokenCleared()
                }
            }
        }
        
        checkTokenCleared()
        wait(for: [clearExpectation], timeout: 2.0)

        // Then: 메모리와 저장소 모두에서 토큰이 삭제되어야 함
        XCTAssertNil(tokenRepository.getAccessToken(), "메모리에서 액세스 토큰이 삭제되지 않았습니다.")
        XCTAssertNil(tokenRepository.getRefreshToken(), "메모리에서 리프레시 토큰이 삭제되지 않았습니다.")
        XCTAssertFalse(mockStorage.hasToken(), "저장소에서 토큰이 삭제되지 않았습니다.")
    }

    func test_clear_이미_비어있는_상태에서_호출해도_안전하다() {
        // Given: 빈 상태의 repository

        // When: 토큰 삭제 (이미 비어있음)
        tokenRepository.clear()

        // Then: 크래시 없이 정상 동작해야 함
        XCTAssertNil(tokenRepository.getAccessToken(), "빈 상태에서 clear 호출 후에도 nil이어야 합니다.")
        XCTAssertNil(tokenRepository.getRefreshToken(), "빈 상태에서 clear 호출 후에도 nil이어야 합니다.")
    }

    // MARK: - 동시성 테스트

    func test_concurrency_동시_업데이트와_조회가_안전하다() throws {
        let expectation = XCTestExpectation(description: "동시성 테스트 완료")
        expectation.expectedFulfillmentCount = 20 // 10개 업데이트 + 10개 조회

        let queue = DispatchQueue.global(qos: .userInitiated)
        var readResults: [String?] = []
        let resultsQueue = DispatchQueue(label: "results", attributes: .concurrent)

        // When: 동시에 업데이트와 조회 작업 수행
        for i in 0..<10 {
            // 업데이트 작업
            queue.async { [weak self] in
                let token = TokenEntity(
                    accessToken: "access_\(i)",
                    refreshToken: "refresh_\(i)"
                )
                self?.tokenRepository.updateToken(token)
                expectation.fulfill()
            }

            // 조회 작업
            queue.async { [weak self] in
                let accessToken = self?.tokenRepository.getAccessToken()
                resultsQueue.async(flags: .barrier) {
                    readResults.append(accessToken)
                    expectation.fulfill()
                }
            }
        }

        wait(for: [expectation], timeout: 5.0)

        // Then: 모든 읽기 결과가 유효해야 함 (nil이거나 유효한 토큰)
        for result in readResults {
            if let token = result {
                XCTAssertTrue(token.hasPrefix("access_"), "읽은 토큰이 유효하지 않습니다: \(token)")
            }
            // nil인 경우도 허용 (업데이트 전 상태)
        }
    }

    func test_concurrency_동시_삭제와_조회가_안전하다() throws {
        // Given: 초기 토큰 저장
        let initialToken = TokenEntity(accessToken: "initial_access", refreshToken: "initial_refresh")
        tokenRepository.updateToken(initialToken)
        
        // 초기 저장 완료 확인
        let setupExpectation = XCTestExpectation(description: "초기 설정 완료")
        
        func checkInitialSetup() {
            if tokenRepository.getAccessToken() == "initial_access" {
                setupExpectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.05) {
                    checkInitialSetup()
                }
            }
        }
        
        checkInitialSetup()
        wait(for: [setupExpectation], timeout: 2.0)

        let expectation = XCTestExpectation(description: "동시 삭제-조회 테스트 완료")
        expectation.expectedFulfillmentCount = 10

        let queue = DispatchQueue.global(qos: .userInitiated)

        // When: 동시에 삭제와 조회 작업 수행
        for _ in 0..<5 {
            // 삭제 작업
            queue.async { [weak self] in
                self?.tokenRepository.clear()
                expectation.fulfill()
            }

            // 조회 작업
            queue.async { [weak self] in
                let _ = self?.tokenRepository.getAccessToken()
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)

        // Then: 최종 상태 폴링으로 확인 (안정성 보장)
        let finalExpectation = XCTestExpectation(description: "최종 삭제 확인")
        
        func checkFinalState() {
            if tokenRepository.getAccessToken() == nil && tokenRepository.getRefreshToken() == nil {
                finalExpectation.fulfill()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.05) {
                    checkFinalState()
                }
            }
        }
        
        checkFinalState()
        wait(for: [finalExpectation], timeout: 3.0)
        
        XCTAssertNil(tokenRepository.getAccessToken(), "최종적으로 토큰이 삭제되어 있어야 합니다.")
        XCTAssertNil(tokenRepository.getRefreshToken(), "최종적으로 토큰이 삭제되어 있어야 합니다.")
    }
}
