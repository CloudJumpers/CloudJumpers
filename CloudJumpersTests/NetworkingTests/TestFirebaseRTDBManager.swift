//
//  TestFirebaseRTDBManager.swift
//  CloudJumpersTests
//
//  Created by Sujay R Subramanian on 10/3/22.
//

import XCTest
@testable import CloudJumpers

private struct StubNetworkEntity: NetworkedEntity {
    private(set) var id: UUID = UUID()
}

class TestFirebaseRTDBManager: XCTestCase {
    func testConstructor_createFirebaseRTDBManager_attributesCorrectlyInitialized() throws {
        let sessionId = CJNetworkConstants.testSessionNamespace + TestUtils.randomLowerAlnumString(length: 5)
        let sut = FirebaseRTDBManager(sessionId: sessionId)

        XCTAssertEqual(sut.sessionId, sessionId)
    }

    func testSendMessage_sendSampleMessage_messageSent() {
        let sessionId = CJNetworkConstants.testSessionNamespace + TestUtils.randomLowerAlnumString(length: 5)
        let sut = FirebaseRTDBManager(sessionId: sessionId)
        sleep(2) // Gives firebase some time to connect ...

        let entityToUpdate = StubNetworkEntity()
        let data = NetworkDataProcessor.prepareOutgoingData(entity: entityToUpdate)

        let outcome = sut.sendMessage(json: data)

        XCTAssertTrue(outcome)
    }
}
