//
//  TestFirebaseAuth.swift
//  CloudJumpersTests
//
//  Created by Sujay R Subramanian on 9/3/22.
//

import XCTest
@testable import CloudJumpers

class TestFirebaseAuthManager: XCTestCase {
    private let firebaseAuthManager = FirebaseAuthManager()

    override func tearDown() async throws {
        try await super.tearDown()
        _ = await firebaseAuthManager.deleteCurrentUser()
    }

    func testLoginUser_invalidUserPassword_userNotReturned() async {
        let testEmail = TestUtils.generateUniqueRandomEmail()
        let testPassword = TestUtils.randomLowerAlnumString(length: 10)

        XCTAssertNil(firebaseAuthManager.getCurrentUser())

        let loginSuccess = await firebaseAuthManager.loginUser(email: testEmail, password: testPassword)

        XCTAssertFalse(loginSuccess)
        XCTAssertNil(firebaseAuthManager.getCurrentUser())
    }

    func testCreateUser_createVariousUsers_expectedCreationOutcomes() async {
        let testEmail = TestUtils.generateUniqueRandomEmail()
        let testEmailTwo = TestUtils.generateUniqueRandomEmail()
        let testPassword = TestUtils.randomLowerAlnumString(length: 10)

        let createSuccessOne = await firebaseAuthManager.createUser(email: testEmail, password: testPassword)
        let userIdOne = firebaseAuthManager.getCurrentUser()?.userId

        let createSuccessTwo = await firebaseAuthManager.createUser(email: testEmail, password: testPassword)
        let userIdTwo = firebaseAuthManager.getCurrentUser()?.userId

        let deleted = await firebaseAuthManager.deleteCurrentUser()
        XCTAssertTrue(deleted)

        let createSuccessThree = await firebaseAuthManager.createUser(email: testEmailTwo, password: testPassword)
        let userIdThree = firebaseAuthManager.getCurrentUser()?.userId

        XCTAssertTrue(createSuccessOne)
        XCTAssertFalse(createSuccessTwo)
        XCTAssertTrue(createSuccessThree)

        XCTAssertNotNil(userIdOne)
        XCTAssertNotNil(userIdTwo)
        XCTAssertNotNil(userIdThree)

        XCTAssertEqual(userIdOne, userIdTwo)
        XCTAssertNotEqual(userIdOne, userIdThree)
    }

    func testUserWorkflow_randomReservedUserPassword_userLifecycleIsCorrect() async {
        let systemUserEmail = TestUtils.generateUniqueRandomEmail()
        let systemUserPassword = TestUtils.randomLowerAlnumString(length: 12)

        XCTAssertNil(firebaseAuthManager.getCurrentUser())

        let createSuccess = await firebaseAuthManager.createUser(
            email: systemUserEmail,
            password: systemUserPassword
        )
        XCTAssertTrue(createSuccess)
        XCTAssertNotNil(firebaseAuthManager.getCurrentUser())

        let loginSuccess = await firebaseAuthManager.loginUser(email: systemUserEmail, password: systemUserPassword)
        XCTAssertTrue(loginSuccess)
        XCTAssertNotNil(firebaseAuthManager.getCurrentUser())
    }
}
