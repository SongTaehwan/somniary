//
//  UserDefaultPropertyWrapperTests.swift
//  SomniaryTests
//
//  Created by 송태환 on 10/2/25.
//

import XCTest
@testable import Somniary

final class UserDefaultPropertyWrapperTests: XCTestCase {

    // MARK: - Test Fixtures

    /// 테스트용 enum 키 정의
    enum TestKey: String, UserDefaultKeyConvertible {
        case userName
        case userAge
        case isEnabled
        case profile
        case optionalName
        case optionalAge
    }

    /// 테스트용 커스텀 Codable 타입
    struct TestProfile: Codable, Equatable {
        let id: String
        let name: String
        let age: Int
    }

    private var testDefaults: UserDefaults!
    private let suiteName = "com.somniary.test.userdefault"

    // MARK: - Setup & Teardown

    override func setUpWithError() throws {
        try super.setUpWithError()
        testDefaults = UserDefaults(suiteName: suiteName)
        testDefaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDownWithError() throws {
        testDefaults?.removePersistentDomain(forName: suiteName)
        testDefaults = nil
        try super.tearDownWithError()
    }

    // MARK: - Non-Optional 타입 테스트

    func test_wrappedValue_String_타입을_저장하고_읽는다() {
        // Given: String 타입의 UserDefault
        var wrapper = UserDefault<TestKey, String>(
            container: testDefaults,
            key: .userName,
            defaultValue: ""
        )

        // When: 값 저장
        wrapper.wrappedValue = "테스트유저"

        // Then: 저장된 값을 읽을 수 있다
        let result = wrapper.wrappedValue
        XCTAssertEqual(result, "테스트유저")
    }

    func test_wrappedValue_Int_타입을_저장하고_읽는다() {
        // Given: Int 타입의 UserDefault
        var wrapper = UserDefault<TestKey, Int>(
            container: testDefaults,
            key: .userAge,
            defaultValue: 0
        )

        // When: 값 저장
        wrapper.wrappedValue = 30

        // Then: 저장된 값을 읽을 수 있다
        let result = wrapper.wrappedValue
        XCTAssertEqual(result, 30)
    }

    func test_wrappedValue_Bool_타입을_저장하고_읽는다() {
        // Given: Bool 타입의 UserDefault
        var wrapper = UserDefault<TestKey, Bool>(
            container: testDefaults,
            key: .isEnabled,
            defaultValue: false
        )

        // When: 값 저장
        wrapper.wrappedValue = true

        // Then: 저장된 값을 읽을 수 있다
        let result = wrapper.wrappedValue
        XCTAssertEqual(result, true)
    }

    func test_wrappedValue_커스텀_Codable_타입을_저장하고_읽는다() {
        // Given: 커스텀 Codable 타입의 UserDefault
        let defaultProfile = TestProfile(id: "", name: "", age: 0)
        var wrapper = UserDefault<TestKey, TestProfile>(
            container: testDefaults,
            key: .profile,
            defaultValue: defaultProfile
        )

        let profile = TestProfile(id: "user123", name: "테스트유저", age: 25)

        // When: 커스텀 타입 저장
        wrapper.wrappedValue = profile

        // Then: 저장된 값을 읽을 수 있다
        let result = wrapper.wrappedValue
        XCTAssertEqual(result, profile)
        XCTAssertEqual(result.id, "user123")
        XCTAssertEqual(result.name, "테스트유저")
        XCTAssertEqual(result.age, 25)
    }

    // MARK: - Optional 타입 테스트

    func test_wrappedValue_Optional_String_nil이_아닌_값을_저장하고_읽는다() {
        // Given: Optional String 타입의 UserDefault
        var wrapper = UserDefault<TestKey, String?>(
            container: testDefaults,
            key: .optionalName,
            defaultValue: nil
        )

        // When: nil이 아닌 값 저장
        wrapper.wrappedValue = "테스트"

        // Then: 저장된 값을 읽을 수 있다
        let result = wrapper.wrappedValue
        XCTAssertNotNil(result)
        XCTAssertEqual(result, "테스트")
    }

    func test_wrappedValue_Optional_nil_값을_설정하면_키가_제거된다() {
        // Given: 값이 저장된 Optional String
        var wrapper = UserDefault<TestKey, String?>(
            container: testDefaults,
            key: .optionalName,
            defaultValue: nil
        )
        wrapper.wrappedValue = "초기값"

        XCTAssertEqual(wrapper.wrappedValue, "초기값")

        // When: nil 값 설정
        wrapper.wrappedValue = nil

        // Then: UserDefaults에서 키가 제거되고 defaultValue 반환
        let result = wrapper.wrappedValue
        XCTAssertNil(result)

        // 실제로 UserDefaults에서 제거되었는지 확인
        let data = testDefaults.data(forKey: TestKey.optionalName.stringValue)
        XCTAssertNil(data, "nil 설정 시 UserDefaults에서 키가 제거되어야 합니다")
    }

    func test_wrappedValue_Optional_Int_nil이_아닌_값을_저장하고_읽는다() {
        // Given: Optional Int 타입의 UserDefault
        var wrapper = UserDefault<TestKey, Int?>(
            container: testDefaults,
            key: .optionalAge,
            defaultValue: nil
        )

        // When: nil이 아닌 값 저장
        wrapper.wrappedValue = 42

        // Then: 저장된 값을 읽을 수 있다
        let result = wrapper.wrappedValue
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 42)
    }

    // MARK: - DefaultValue 테스트

    func test_wrappedValue_존재하지_않는_키에_대해_defaultValue를_반환한다() {
        // Given: 저장된 값이 없는 UserDefault
        let wrapper = UserDefault<TestKey, String>(
            container: testDefaults,
            key: .userName,
            defaultValue: "기본값"
        )

        // When: 값 읽기
        let result = wrapper.wrappedValue

        // Then: defaultValue 반환
        XCTAssertEqual(result, "기본값")
    }

    func test_wrappedValue_디코딩_실패_시_defaultValue를_반환한다() {
        // Given: 손상된 데이터가 저장된 상태
        let corruptedData = "invalid json data".data(using: .utf8)!
        testDefaults.set(corruptedData, forKey: TestKey.profile.stringValue)

        let defaultProfile = TestProfile(id: "default", name: "기본", age: 0)
        let wrapper = UserDefault<TestKey, TestProfile>(
            container: testDefaults,
            key: .profile,
            defaultValue: defaultProfile
        )

        // When: 디코딩 시도
        let result = wrapper.wrappedValue

        // Then: defaultValue 반환
        XCTAssertEqual(result, defaultProfile)
    }

    // MARK: - 키 타입 호환성 테스트

    func test_init_String_키를_사용할_수_있다() {
        // Given: String을 키로 사용
        var wrapper = UserDefault<String, String>(
            container: testDefaults,
            key: "test_string_key",
            defaultValue: ""
        )

        // When: 값 저장 및 읽기
        wrapper.wrappedValue = "문자열키테스트"
        let result = wrapper.wrappedValue

        // Then: 정상 동작
        XCTAssertEqual(result, "문자열키테스트")
    }

    func test_init_Enum_키를_사용할_수_있다() {
        // Given: Enum을 키로 사용 (UserDefaultKeyConvertible 채택)
        var wrapper = UserDefault<TestKey, String>(
            container: testDefaults,
            key: .userName,
            defaultValue: ""
        )

        // When: 값 저장 및 읽기
        wrapper.wrappedValue = "enum키테스트"
        let result = wrapper.wrappedValue

        // Then: 정상 동작
        XCTAssertEqual(result, "enum키테스트")
    }

    // MARK: - ExpressibleByNilLiteral 생성자 테스트

    func test_init_nil_허용_생성자가_정상_작동한다() {
        // Given: ExpressibleByNilLiteral 생성자 사용
        var wrapper = UserDefault<TestKey, String?>(
            container: testDefaults,
            key: .optionalName
        )

        // When: 값 저장 없이 읽기
        let result = wrapper.wrappedValue

        // Then: nil 반환 (defaultValue가 nil)
        XCTAssertNil(result)

        // When: 값 저장 후 읽기
        wrapper.wrappedValue = "테스트"
        let updatedResult = wrapper.wrappedValue

        // Then: 저장된 값 반환
        XCTAssertEqual(updatedResult, "테스트")
    }

    // MARK: - 덮어쓰기 테스트

    func test_wrappedValue_기존_값을_덮어쓸_수_있다() {
        // Given: 값이 저장된 상태
        var wrapper = UserDefault<TestKey, String>(
            container: testDefaults,
            key: .userName,
            defaultValue: ""
        )
        wrapper.wrappedValue = "초기값"

        // When: 새로운 값으로 덮어쓰기
        wrapper.wrappedValue = "업데이트된값"

        // Then: 새로운 값이 반환된다
        let result = wrapper.wrappedValue
        XCTAssertEqual(result, "업데이트된값")
        XCTAssertNotEqual(result, "초기값")
    }

    func test_wrappedValue_같은_키에_다른_타입을_덮어쓸_수_있다() {
        // Given: String 타입으로 값 저장
        var stringWrapper = UserDefault<TestKey, String>(
            container: testDefaults,
            key: .userName,
            defaultValue: ""
        )
        stringWrapper.wrappedValue = "문자열"

        // When: 같은 키에 커스텀 타입으로 덮어쓰기
        let profile = TestProfile(id: "123", name: "테스트", age: 30)
        var profileWrapper = UserDefault<TestKey, TestProfile>(
            container: testDefaults,
            key: .userName,  // 같은 키 사용
            defaultValue: TestProfile(id: "", name: "", age: 0)
        )
        profileWrapper.wrappedValue = profile

        // Then: 새로운 타입의 값이 저장됨
        let result = profileWrapper.wrappedValue
        XCTAssertEqual(result, profile)

        // 이전 String 타입으로 읽으면 디코딩 실패로 defaultValue 반환
        let stringResult = stringWrapper.wrappedValue
        XCTAssertEqual(stringResult, "")  // defaultValue
    }

    // MARK: - 데이터 격리 테스트

    func test_init_서로_다른_container는_데이터가_격리된다() {
        // Given: 서로 다른 UserDefaults container
        let container1 = UserDefaults(suiteName: "com.test.container1")!
        let container2 = UserDefaults(suiteName: "com.test.container2")!

        defer {
            container1.removePersistentDomain(forName: "com.test.container1")
            container2.removePersistentDomain(forName: "com.test.container2")
        }

        var wrapper1 = UserDefault<TestKey, String>(
            container: container1,
            key: .userName,
            defaultValue: ""
        )

        var wrapper2 = UserDefault<TestKey, String>(
            container: container2,
            key: .userName,
            defaultValue: ""
        )

        // When: container1에만 값 저장
        wrapper1.wrappedValue = "container1값"

        // Then: container2는 영향받지 않음
        XCTAssertEqual(wrapper1.wrappedValue, "container1값")
        XCTAssertEqual(wrapper2.wrappedValue, "")  // defaultValue
    }

    func test_wrappedValue_서로_다른_키는_독립적으로_동작한다() {
        // Given: 같은 container의 다른 키
        var wrapper1 = UserDefault<TestKey, String>(
            container: testDefaults,
            key: .userName,
            defaultValue: ""
        )

        var wrapper2 = UserDefault<TestKey, Int>(
            container: testDefaults,
            key: .userAge,
            defaultValue: 0
        )

        // When: 각각 값 저장
        wrapper1.wrappedValue = "테스트유저"
        wrapper2.wrappedValue = 25

        // Then: 서로 영향받지 않음
        XCTAssertEqual(wrapper1.wrappedValue, "테스트유저")
        XCTAssertEqual(wrapper2.wrappedValue, 25)

        // When: 한 키만 삭제 (Optional로 nil 설정)
        var optionalWrapper = UserDefault<TestKey, String?>(
            container: testDefaults,
            key: .userName,
            defaultValue: nil
        )
        optionalWrapper.wrappedValue = nil

        // Then: 다른 키는 영향받지 않음
        XCTAssertEqual(wrapper2.wrappedValue, 25)
    }
}
