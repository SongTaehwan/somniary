//
//  KeychainStorageTests.swift
//  SomniaryTests
//
//  Created by 송태환 on 9/15/25.
//

import XCTest
@testable import Somniary

final class KeychainStorageTests: XCTestCase {
    
    // MARK: - Test Fixtures
    
    /// 테스트용 키 열거형 정의
    enum TestKey: String, CaseIterable {
        case token = "test_token"
        case user = "test_user"
        case settings = "test_settings"
    }
    
    /// 테스트용 데이터 모델
    struct TestUser: Codable, Equatable {
        let id: String
        let name: String
        let email: String
    }
    
    private var keychainStorage: KeychainStorage<TestKey>!
    private let testService = "com.somniary.test"
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        keychainStorage = KeychainStorage<TestKey>(service: testService)
        keychainStorage.clear()
    }
    
    override func tearDownWithError() throws {
        keychainStorage?.clear()
        keychainStorage = nil
        try super.tearDownWithError()
    }
    
    // MARK: - 기본 기능 테스트
    
    func test_save_성공적으로_토큰을_저장한다() throws {
        // Given: 저장할 토큰 데이터
        let token = TokenEntity(accessToken: "access_token", refreshToken: "refresh_token")
        
        // When: 키체인에 토큰 저장
        try keychainStorage.save(token, for: .token)
        
        // Then: 저장된 토큰을 조회할 수 있다
        let retrievedToken: TokenEntity? = keychainStorage.retrieve(for: .token)
        XCTAssertNotNil(retrievedToken)
        XCTAssertEqual(retrievedToken?.accessToken, "access_token", "accessToken이 일치하지 않습니다.")
        XCTAssertEqual(retrievedToken?.refreshToken, "refresh_token", "refreshToken이 일치하지 않습니다.")
    }
    
    func test_save_성공적으로_사용자_정보를_저장한다() throws {
        // Given: 저장할 사용자 데이터
        let user = TestUser(id: "user123", name: "테스트유저", email: "test@example.com")
        
        // When: 키체인에 사용자 정보 저장
        try keychainStorage.save(user, for: .user)
        
        // Then: 저장된 사용자 정보를 조회할 수 있다
        let retrievedUser: TestUser? = keychainStorage.retrieve(for: .user)
        XCTAssertNotNil(retrievedUser)
        XCTAssertEqual(retrievedUser, user)
        XCTAssertEqual(retrievedUser?.id, user.id, "id가 일치하지 않습니다.")
        XCTAssertEqual(retrievedUser?.name, user.name, "name이 일치하지 않습니다.")
        XCTAssertEqual(retrievedUser?.email, user.email, "email이 일치하지 않습니다.")
    }

    func test_save_기존_데이터_덮어쓰기가_정상_작동한다() throws {
        // Given: 기존 데이터 저장
        let originalUser = TestUser(id: "original", name: "원본", email: "original@test.com")
        try keychainStorage.save(originalUser, for: .user)
        
        // When: 같은 키에 새 데이터 저장
        let updatedUser = TestUser(id: "updated", name: "수정", email: "updated@test.com")
        try keychainStorage.save(updatedUser, for: .user)
        
        // Then: 새 데이터로 업데이트됨
        let retrieved: TestUser? = keychainStorage.retrieve(for: .user)
        XCTAssertEqual(retrieved, updatedUser)
        XCTAssertNotEqual(retrieved, originalUser)
    }
    
    func test_retrieve_존재하지_않는_키에_대해_nil을_반환한다() {
        // Given: 빈 키체인 상태
        
        // When: 존재하지 않는 키로 조회
        let result: TokenEntity? = keychainStorage.retrieve(for: .token)
        
        // Then: nil을 반환한다
        XCTAssertNil(result, "존재하지 않는 키에 대해 nil을 반환하지 않습니다.")
    }
    
    func test_clear_단일_키를_성공적으로_삭제한다() throws {
        // Given: 키체인에 저장된 데이터
        let token = TokenEntity(accessToken: "access123", refreshToken: "refresh456")
        try keychainStorage.save(token, for: .token)
        
        let user = TestUser(id: "user123", name: "테스트유저", email: "test@example.com")
        try keychainStorage.save(user, for: .user)
        
        // When: 특정 키만 삭제
        keychainStorage.clear(key: .token)
        
        // Then: 해당 키의 데이터만 삭제되고 다른 키는 유지된다
        let retrievedToken: TokenEntity? = keychainStorage.retrieve(for: .token)
        let retrievedUser: TestUser? = keychainStorage.retrieve(for: .user)
        
        XCTAssertNil(retrievedToken, "특정 키의 데이터만 삭제되지 않습니다.")
        XCTAssertNotNil(retrievedUser, "특정 키의 데이터만 삭제되지 않습니다.")
        XCTAssertEqual(retrievedUser, user)
    }
    
    func test_clear_복수_키를_성공적으로_삭제한다() throws {
        // Given: 키체인에 여러 데이터 저장
        let token = TokenEntity(accessToken: "access123", refreshToken: "refresh456")
        let user = TestUser(id: "user123", name: "테스트유저", email: "test@example.com")
        let settings = ["theme": "dark"]
        
        try keychainStorage.save(token, for: .token)
        try keychainStorage.save(user, for: .user)
        try keychainStorage.save(settings, for: .settings)
        
        // When: 특정 키들만 삭제
        keychainStorage.clear(keys: [.token, .user])
        
        // Then: 지정된 키들만 삭제되고 나머지는 유지된다
        let retrievedToken: TokenEntity? = keychainStorage.retrieve(for: .token)
        let retrievedUser: TestUser? = keychainStorage.retrieve(for: .user)
        let retrievedSettings: [String: String]? = keychainStorage.retrieve(for: .settings)
        
        XCTAssertNil(retrievedToken, "지정된 키의 데이터가 삭제되지 않습니다.")
        XCTAssertNil(retrievedUser, "지정된 키의 데이터가 삭제되지 않습니다.")
        XCTAssertNotNil(retrievedSettings, "지정하지 않은 키의 데이터가 삭제 되었습니다.")
        XCTAssertEqual(retrievedSettings?["theme"], "dark", "지정하지 않은 키의 데이터가 일치하지 않습니다.")
    }
    
    func test_clear_전체_키를_성공적으로_삭제한다() throws {
        // Given: 키체인에 모든 타입의 데이터 저장
        let token = TokenEntity(accessToken: "access123", refreshToken: "refresh456")
        let user = TestUser(id: "user123", name: "테스트유저", email: "test@example.com")
        let settings = ["theme": "dark"]
        
        try keychainStorage.save(token, for: .token)
        try keychainStorage.save(user, for: .user)
        try keychainStorage.save(settings, for: .settings)
        
        // When: 전체 키 삭제 (기본값 사용)
        keychainStorage.clear()
        
        // Then: 모든 데이터가 삭제된다
        let retrievedToken: TokenEntity? = keychainStorage.retrieve(for: .token)
        let retrievedUser: TestUser? = keychainStorage.retrieve(for: .user)
        let retrievedSettings: [String: String]? = keychainStorage.retrieve(for: .settings)
        
        XCTAssertNil(retrievedToken, "모든 데이터가 삭제되지 않습니다.")
        XCTAssertNil(retrievedUser, "모든 데이터가 삭제되지 않습니다.")
        XCTAssertNil(retrievedSettings, "모든 데이터가 삭제되지 않습니다.")
    }
    
    // MARK: - 동시성 테스트
    
    func test_concurrency_동시_저장_및_조회_시_데이터_무결성을_보장한다() throws {
        let expectation = XCTestExpectation(description: "동시성 테스트 완료")
        expectation.expectedFulfillmentCount = 10
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        var results: [TestUser?] = Array(repeating: nil, count: 10)
        let resultsQueue = DispatchQueue(label: "results", attributes: .concurrent)
        
        // Given: 동시에 여러 스레드에서 저장/조회
        for i in 0..<10 {
            queue.async { [weak self] in
                guard let self = self else { return }
                
                let user = TestUser(id: "user\(i)", name: "사용자\(i)", email: "user\(i)@test.com")
                
                do {
                    // When: 동시에 저장하고 즉시 조회
                    try self.keychainStorage.save(user, for: .user)
                    let retrieved: TestUser? = self.keychainStorage.retrieve(for: .user)
                    
                    // Then: 조회된 데이터가 유효하다
                    resultsQueue.async(flags: .barrier) {
                        results[i] = retrieved
                        expectation.fulfill()
                    }
                } catch {
                    XCTFail("저장 실패: \(error)")
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 5.0)

        // 최종 상태 검증 추가
        let finalResult: TestUser? = keychainStorage.retrieve(for: .user)
        XCTAssertNotNil(finalResult, "최종 결과가 nil입니다")
        XCTAssertTrue(finalResult?.id.hasPrefix("user") == true, "최종 결과가 유효하지 않습니다")
        
        // 모든 결과가 유효한 사용자 데이터인지 확인 (어떤 사용자든 상관없이)
        for result in results {
            XCTAssertNotNil(result)
            XCTAssertTrue(result?.id.hasPrefix("user") == true)
        }
    }
    
    func test_concurrency_동시_삭제_작업의_안전성을_보장한다() throws {
        // Given: 초기 데이터 저장
        let initialUser = TestUser(id: "initial", name: "초기사용자", email: "initial@test.com")
        try keychainStorage.save(initialUser, for: .user)
        
        let expectation = XCTestExpectation(description: "동시 삭제 테스트 완료")
        expectation.expectedFulfillmentCount = 5
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        // When: 동시에 여러 스레드에서 삭제 작업
        for _ in 0..<5 {
            queue.async { [weak self] in
                self?.keychainStorage.clear(key: .user)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
        
        // Then: 최종적으로 데이터가 삭제되어 있다
        let result: TestUser? = keychainStorage.retrieve(for: .user)
        XCTAssertNil(result)
    }
    
    /// 검증 기준: 순서가 아닌 데이터 무결성
    func test_concurrency_읽기_쓰기_동시_접근_시_데이터_일관성을_보장한다() throws {
        // Given: 초기 데이터 저장
        let initialUser = TestUser(id: "initial", name: "초기사용자", email: "initial@test.com")
        try keychainStorage.save(initialUser, for: .user)
        
        let expectation = XCTestExpectation(description: "읽기-쓰기 동시성 테스트 완료")
        expectation.expectedFulfillmentCount = 20 // 10개 읽기 + 10개 쓰기
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        var readResults: [TestUser?] = []
        let resultsQueue = DispatchQueue(label: "results", attributes: .concurrent)
        
        // When: 동시에 읽기와 쓰기 작업 수행
        for i in 0..<10 {
            // 읽기 작업
            queue.async { [weak self] in
                let result: TestUser? = self?.keychainStorage.retrieve(for: .user)
                resultsQueue.async(flags: .barrier) {
                    readResults.append(result)
                    expectation.fulfill()
                }
            }
            
            // 쓰기 작업
            queue.async { [weak self] in
                let newUser = TestUser(id: "user\(i)", name: "사용자\(i)", email: "user\(i)@test.com")
                
                do {
                    try self?.keychainStorage.save(newUser, for: .user)
                    expectation.fulfill()
                } catch {
                    XCTFail("동시 쓰기 실패: \(error)")
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        // Then: 모든 읽기 결과가 유효한 데이터여야 함 (nil이거나 유효한 사용자)
        for result in readResults {
            if let user = result {
                XCTAssertFalse(user.id.isEmpty, "읽은 사용자 ID가 비어있습니다.")
                XCTAssertFalse(user.name.isEmpty, "읽은 사용자 이름이 비어있습니다.")
                XCTAssertFalse(user.email.isEmpty, "읽은 사용자 이메일이 비어있습니다.")
            }
        }
    }
    
    func test_concurrency_서로_다른_키에_대한_동시_작업은_차단되지_않는다() throws {
        let expectation = XCTestExpectation(description: "다른 키 동시 작업 테스트")
        expectation.expectedFulfillmentCount = 6 // 3개 키 * 2개 작업
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // When: 서로 다른 키에 대해 동시에 저장 작업 수행
        queue.async { [weak self] in
            let token = TokenEntity(accessToken: "access1", refreshToken: "refresh1")
            do {
                try self?.keychainStorage.save(token, for: .token)
                expectation.fulfill()
            } catch {
                XCTFail("토큰 저장 실패: \(error)")
                expectation.fulfill()
            }
        }
        
        queue.async { [weak self] in
            let user = TestUser(id: "user1", name: "사용자1", email: "user1@test.com")
            do {
                try self?.keychainStorage.save(user, for: .user)
                expectation.fulfill()
            } catch {
                XCTFail("사용자 저장 실패: \(error)")
                expectation.fulfill()
            }
        }
        
        queue.async { [weak self] in
            let settings = ["theme": "dark", "language": "ko"]
            do {
                try self?.keychainStorage.save(settings, for: .settings)
                expectation.fulfill()
            } catch {
                XCTFail("설정 저장 실패: \(error)")
                expectation.fulfill()
            }
        }
        
        // 각 키에서 데이터 조회도 동시에 수행
        queue.async { [weak self] in
            let _: TokenEntity? = self?.keychainStorage.retrieve(for: .token)
            expectation.fulfill()
        }
        
        queue.async { [weak self] in
            let _: TestUser? = self?.keychainStorage.retrieve(for: .user)
            expectation.fulfill()
        }
        
        queue.async { [weak self] in
            let _: [String: String]? = self?.keychainStorage.retrieve(for: .settings)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then: 작업이 합리적인 시간 내에 완료되어야 함 (병렬 처리 확인)
        XCTAssertLessThan(endTime - startTime, 5.0, "서로 다른 키 작업이 너무 오래 걸립니다. 병렬 처리가 제대로 되지 않을 수 있습니다.")
        
        // 모든 데이터가 정상적으로 저장되었는지 확인
        let token: TokenEntity? = keychainStorage.retrieve(for: .token)
        let user: TestUser? = keychainStorage.retrieve(for: .user)
        let settings: [String: String]? = keychainStorage.retrieve(for: .settings)
        
        XCTAssertNotNil(token, "토큰이 저장되지 않았습니다.")
        XCTAssertNotNil(user, "사용자가 저장되지 않았습니다.")
        XCTAssertNotNil(settings, "설정이 저장되지 않았습니다.")
    }
    
    func test_concurrency_동일_스레드에서_연속_호출_시_성능을_보장한다() throws {
        // Given: 초기 데이터 저장
        let initialUser = TestUser(id: "initial", name: "초기사용자", email: "initial@test.com")
        try keychainStorage.save(initialUser, for: .user)
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // When: 동일 스레드에서 연속적으로 여러 번 조회
        for _ in 0..<100 {
            let result: TestUser? = keychainStorage.retrieve(for: .user)
            XCTAssertNotNil(result)
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then: 합리적인 시간 내에 완료되어야 함
        XCTAssertLessThan(endTime - startTime, 0.5, "연속 조회가 너무 오래 걸립니다.")
    }
    
    func test_concurrency_스레드_안전성_메모리_무결성을_보장한다() throws {
        let expectation = XCTestExpectation(description: "스레드 안전성 메모리 무결성 테스트")
        expectation.expectedFulfillmentCount = 100
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        var successCount = 0
        let countQueue = DispatchQueue(label: "count", attributes: .concurrent)
        
        // When: 대량의 동시 작업으로 메모리 무결성 테스트
        for i in 0..<100 {
            queue.async { [weak self] in
                guard let self = self else {
                    expectation.fulfill()
                    return
                }
                
                let user = TestUser(
                    id: "stress_test_\(i)",
                    name: "스트레스테스트\(i)",
                    email: "stress\(i)@test.com"
                )
                
                do {
                    // 저장 후 즉시 조회하여 데이터 무결성 확인
                    try self.keychainStorage.save(user, for: .user)
                    let retrieved: TestUser? = self.keychainStorage.retrieve(for: .user)
                    
                    if let retrieved = retrieved,
                       retrieved.id.contains("stress_test_") {
                        countQueue.async(flags: .barrier) {
                            successCount += 1
                        }
                    }
                    
                    expectation.fulfill()
                } catch {
                    XCTFail("스트레스 테스트 저장 실패: \(error)")
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 15.0)
        
        // Then: 대부분의 작업이 성공해야 함 (메모리 무결성 확인)
        XCTAssertGreaterThan(successCount, 99, "스레드 안전성 테스트에서 너무 많은 실패가 발생했습니다.")
    }
}
