//
//  AppLaunchChecker.swift
//  SomniaryTests
//
//  Created by 송태환 on 9/14/25.
//

import XCTest
@testable import Somniary

final class AppLaunchCheckerTests: XCTestCase {

    func test_isFirstLaunch_첫_실행시_true를_반환하고_두번째_실행시_false를_반환한다() throws {
        // 테스트용 UserDefaults와 고유 키 사용
        let testKey = "test.first.launch.key"
        let testDefaults = UserDefaults(suiteName: "test.first.launch")!

        // 첫 실행 테스트
        let firstChecker = AppLaunchChecker(storage: testDefaults, key: testKey)
        XCTAssertTrue(firstChecker.isFirstLaunch)

        // 두 번째 실행 테스트
        let secondChecker = AppLaunchChecker(storage: testDefaults, key: testKey)
        XCTAssertFalse(secondChecker.isFirstLaunch)
    }

    func test_isFirstLaunch_서로_다른_키로_독립적으로_동작한다() throws {
        // 서로 다른 키로 독립적 테스트
        let testDefaults = UserDefaults(suiteName: "test.multiple")!

        let checker1 = AppLaunchChecker(storage: testDefaults, key: "test.multiple.key1")
        let checker2 = AppLaunchChecker(storage: testDefaults, key: "test.multiple.key2")

        XCTAssertTrue(checker1.isFirstLaunch)
        XCTAssertTrue(checker2.isFirstLaunch) // 서로 독립적
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removePersistentDomain(forName: "test.first.launch")
        UserDefaults.standard.removePersistentDomain(forName: "test.multiple")
        try super.tearDownWithError()
    }
}
