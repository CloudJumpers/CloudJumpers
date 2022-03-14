//
//  FirebaseRTDBManager.swift
//  CloudJumpers
//
//  Uses Firebase real-time database
//
//  Created by Sujay R Subramanian on 10/3/22.
//

import Foundation
import FirebaseDatabase

class FirebaseRTDBManager: NetworkingManager {
    var sessionId: String?

    private var databaseRef: DatabaseReference

    init(sessionId: String? = nil) {
        self.sessionId = sessionId

        self.databaseRef = Database
            .database()
            .reference(withPath: CJNetworkConstants.gameSessionContainer)

        setupListener()
    }

    deinit {
        self.databaseRef.removeAllObservers()
    }

    func sendMessage(json: CJNetworkData) -> Bool {
        guard let validSessionId = sessionId else {
            return false
        }

        let asString = json as String

        databaseRef
            .child(validSessionId)
            .childByAutoId()
            .setValue(asString)

        return true
    }

    func receiveMessage(json: CJNetworkData) {
        guard sessionId != nil else {
            return
        }

        NetworkDataProcessor.parseIncomingData(receivedData: json)
    }

    private func setupListener() {
        guard let validSessionId = sessionId else {
            fatalError("Session id not configured for listening")
        }

        databaseRef.child(validSessionId).observe(.value) { snapshot in
            for obj in snapshot.children.allObjects {
                guard let data = obj as? CJNetworkData else {
                    continue
                }

                self.receiveMessage(json: data)
            }
        }
    }
}
