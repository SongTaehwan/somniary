//
//  KeyStoringTests.swift
//  SomniaryTests
//
//  Created by 송태환 on 9/14/25.
//

import XCTest
@testable import Somniary

final class KeyStoringTests: XCTestCase {

    // MARK: - Test Storage Implementation

    enum TestKey: String, CaseIterable {
        case testString = "test_string"
        case testInt = "test_int"
        case testBool = "test_bool"
        case testModel = "test_token"
        case testArray = "test_array"
        case nonExistentKey = "non_existent"
    }

    /// 테스트용 KeyStoring 구현체
    struct TestKeyStorage: KeyStoring {
        typealias ValueKey = TestKey
    }

    /// 테스트용 커스텀 구조체
    struct TestModel: Codable, Equatable {
        let id: Int
        let name: String
        let isActive: Bool
    }

    private var storage: TestKeyStorage!

    // MARK: - Setup & Teardown

    override func setUpWithError() throws {
        try super.setUpWithError()
        storage = TestKeyStorage()
        storage.clear()
    }

    override func tearDownWithError() throws {
        storage.clear()
        storage = nil
        try super.tearDownWithError()
    }

    // MARK: - 기본 저장/조회 테스트

    /// 문자열 저장 및 조회 테스트
    func test_save_성공적으로_문자열을_저장하고_조회한다() throws {
        // Given
        let testValue = "Hello, KeyStoring!"

        // When
        try storage.save(testValue, for: .testString)
        let retrievedValue: String? = storage.retrieve(for: .testString)

        // Then
        XCTAssertEqual(retrievedValue, testValue, "저장된 문자열이 정확히 조회되어야 함")
    }

    /// 정수 저장 및 조회 테스트
    func test_save_성공적으로_정수를_저장하고_조회한다() throws {
        // Given
        let testValue = 42

        // When
        try storage.save(testValue, for: .testInt)
        let retrievedValue: Int? = storage.retrieve(for: .testInt)

        // Then
        XCTAssertEqual(retrievedValue, testValue, "저장된 정수가 정확히 조회되어야 함")
    }

    /// 불리언 저장 및 조회 테스트
    func test_save_성공적으로_불리언을_저장하고_조회한다() throws {
        // Given
        let testValue = true

        // When
        try storage.save(testValue, for: .testBool)
        let retrievedValue: Bool? = storage.retrieve(for: .testBool)

        // Then
        XCTAssertEqual(retrievedValue, testValue, "저장된 불리언이 정확히 조회되어야 함")
    }

    /// 커스텀 구조체 저장 및 조회 테스트
    func test_save_성공적으로_커스텀_구조체를_저장하고_조회한다() throws {
        // Given
        let testModel = TestModel(id: 1, name: "Test User", isActive: true)

        // When
        try storage.save(testModel, for: .testModel)
        let retrievedModel: TestModel? = storage.retrieve(for: .testModel)

        // Then
        XCTAssertEqual(retrievedModel, testModel, "저장된 커스텀 구조체가 정확히 조회되어야 함")
    }

    /// 배열 저장 및 조회 테스트
    func test_save_성공적으로_배열을_저장하고_조회한다() throws {
        // Given
        let testArray = ["apple", "banana", "cherry"]

        // When
        try storage.save(testArray, for: .testArray)
        let retrievedArray: [String]? = storage.retrieve(for: .testArray)

        // Then
        XCTAssertEqual(retrievedArray, testArray, "저장된 배열이 정확히 조회되어야 함")
    }

    /// 명시적 타입 지정 조회 테스트
    func test_retrieve_명시적_타입_지정으로_정확히_조회한다() throws {
        // Given
        let testValue = 100
        try storage.save(testValue, for: .testInt)

        // When
        let retrievedValue = storage.retrieve(type: Int.self, for: .testInt)

        // Then
        XCTAssertEqual(retrievedValue, testValue, "명시적 타입 지정으로 정확히 조회되어야 함")
    }

    // MARK: - 에러 처리 테스트

    /// 존재하지 않는 키 조회 시 nil 반환 테스트
    func test_retrieve_존재하지_않는_키에_대해_nil을_반환한다() {
        // When
        let retrievedValue: String? = storage.retrieve(for: .nonExistentKey)

        // Then
        XCTAssertNil(retrievedValue, "존재하지 않는 키 조회 시 nil을 반환해야 함")
    }

    /// 잘못된 타입으로 디코딩 시도 테스트
    func test_retrieve_잘못된_타입으로_디코딩_시도시_nil을_반환한다() throws {
        // Given - 문자열 저장
        try storage.save("not a number", for: .testString)

        // When - 정수로 디코딩 시도
        let retrievedValue: Int? = storage.retrieve(for: .testString)

        // Then
        XCTAssertNil(retrievedValue, "잘못된 타입으로 디코딩 시도 시 nil을 반환해야 함")
    }

    /// 동일 키에 다른 타입 데이터 덮어쓰기 테스트
    func test_save_동일_키에_다른_타입_데이터로_덮어쓰기한다() throws {
        // Given - 먼저 문자열 저장
        try storage.save("original string", for: .testString)

        // When - 동일 키에 정수 저장
        try storage.save(999, for: .testString)

        // Then - 정수로 조회 가능, 문자열로는 조회 불가
        let intValue: Int? = storage.retrieve(for: .testString)
        let stringValue: String? = storage.retrieve(for: .testString)

        XCTAssertEqual(intValue, 999, "새로 저장된 정수가 조회되어야 함")
        XCTAssertNil(stringValue, "이전 타입으로는 조회되지 않아야 함")
    }

    // MARK: - 삭제 기능 테스트

    /// 단일 키 삭제 테스트
    func test_clear_단일_키를_성공적으로_삭제한다() throws {
        // Given
        try storage.save("test value", for: .testString)
        try storage.save(42, for: .testInt)

        // When - 하나의 키만 삭제
        storage.clear(.testString)

        // Then
        let deletedValue: String? = storage.retrieve(for: .testString)
        let remainingValue: Int? = storage.retrieve(for: .testInt)

        XCTAssertNil(deletedValue, "삭제된 키의 값은 nil이어야 함")
        XCTAssertEqual(remainingValue, 42, "다른 키의 값은 유지되어야 함")
    }

    /// 복수 키 삭제 테스트
    func test_clear_복수_키를_성공적으로_삭제한다() throws {
        // Given
        try storage.save("test1", for: .testString)
        try storage.save(42, for: .testInt)
        try storage.save(TestModel(id: 1, name: "test", isActive: true), for: .testModel)

        // When - 특정 키들만 삭제
        storage.clear(keys: [.testString, .testInt])

        // Then
        let deletedString: String? = storage.retrieve(for: .testString)
        let deletedInt: Int? = storage.retrieve(for: .testInt)
        let remainingModel: TestModel? = storage.retrieve(for: .testModel)

        XCTAssertNil(deletedString, "삭제된 문자열 키의 값은 nil이어야 함")
        XCTAssertNil(deletedInt, "삭제된 정수 키의 값은 nil이어야 함")
        XCTAssertNotNil(remainingModel, "삭제되지 않은 키의 값은 유지되어야 함")
    }

    /// 전체 키 삭제 테스트 (기본값 사용)
    func test_clear_전체_키를_성공적으로_삭제한다() throws {
        // Given
        try storage.save("test1", for: .testString)
        try storage.save(42, for: .testInt)
        try storage.save(TestModel(id: 1, name: "test", isActive: true), for: .testModel)

        // When - 모든 키 삭제 (기본값 사용)
        storage.clear()

        // Then
        let stringValue: String? = storage.retrieve(for: .testString)
        let intValue: Int? = storage.retrieve(for: .testInt)
        let modelValue: TestModel? = storage.retrieve(for: .testModel)

        XCTAssertNil(stringValue, "모든 키가 삭제되어야 함")
        XCTAssertNil(intValue, "모든 키가 삭제되어야 함")
        XCTAssertNil(modelValue, "모든 키가 삭제되어야 함")
    }

    /// 존재하지 않는 키 삭제 시 에러 없이 처리 테스트
    func test_clear_존재하지_않는_키_삭제시_에러_없이_처리한다() {
        // When & Then - 에러 없이 실행되어야 함
        XCTAssertNoThrow(storage.clear(.nonExistentKey), "존재하지 않는 키 삭제 시 에러가 발생하지 않아야 함")
    }

    // MARK: - 실제 TokenEntity 테스트

    /// 실제 앱에서 사용하는 TokenEntity 저장/조회 테스트
    func test_save_실제_TokenEntity를_성공적으로_저장하고_조회한다() throws {
        // Given
        let token = TokenEntity(accessToken: "access_token_123", refreshToken: "refresh_token_456")

        // When
        try storage.save(token, for: .testModel)
        let retrievedToken: TokenEntity? = storage.retrieve(for: .testModel)

        // Then
        XCTAssertEqual(retrievedToken?.accessToken, token.accessToken, "액세스 토큰이 정확히 저장/조회되어야 함")
        XCTAssertEqual(retrievedToken?.refreshToken, token.refreshToken, "리프레시 토큰이 정확히 저장/조회되어야 함")
    }
}
