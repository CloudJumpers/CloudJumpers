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
        let currentUser = firebaseAuthManager.getActiveUser()
        try await currentUser?.delete()
    }

    func testLoginUser_invalidUserPassword_userNotReturned() async {
        let testEmail = "fakeemail123@xyz23rdwqwqf.com"
        let testPassword = "ewfwqqwdffweve"

        XCTAssertNil(firebaseAuthManager.getActiveUser())

        let loginOutcome = await firebaseAuthManager.loginUser(email: testEmail, password: testPassword)

        XCTAssertNil(loginOutcome)
        XCTAssertNil(firebaseAuthManager.getActiveUser())
    }

    func testUserWorkflow_randomReservedUserPassword_userLifecycleIsCorrect() async {
        let systemUserEmail = "reserved\(TestUtils.randomLowerAlnumString(length: 5))@cloudjumpers3217.com"
        let systemUserPassword = TestUtils.randomLowerAlnumString(length: 12)

        XCTAssertNil(firebaseAuthManager.getActiveUser())

        guard let createdUser = await firebaseAuthManager.createUser(email: systemUserEmail,
                                                                     password: systemUserPassword) else {
            XCTFail("Expected successful user creation")
            return
        }

        let loggedInUser = await firebaseAuthManager.loginUser(email: systemUserEmail, password: systemUserPassword)
        XCTAssertNotNil(loggedInUser)

        XCTAssertNotNil(firebaseAuthManager.getActiveUser())
        XCTAssertEqual(loggedInUser, firebaseAuthManager.getActiveUser())

        // Test specific attributes
        XCTAssertEqual(createdUser.email, loggedInUser?.email)
        XCTAssertEqual(createdUser.email, firebaseAuthManager.getActiveUser()?.email)
        XCTAssertEqual(createdUser.email, systemUserEmail)

        XCTAssertEqual(createdUser.uid, loggedInUser?.uid)
        XCTAssertEqual(createdUser.uid, firebaseAuthManager.getActiveUser()?.uid)

        XCTAssertFalse(createdUser.isAnonymous)
        XCTAssertFalse(createdUser.isEmailVerified)
    }
}
