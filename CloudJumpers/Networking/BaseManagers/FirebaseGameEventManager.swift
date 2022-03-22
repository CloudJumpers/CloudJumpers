//
//  FirebaseGameEventManager.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 22/3/22.
//

import Foundation
import FirebaseDatabase

class FirebaseGameEventManager {
    private let locationRef: DatabaseReference

    init() {
        self.locationRef = Database.database().reference(withPath: "/updates")
        listen()
    }

    deinit {
        locationRef.removeAllObservers()
    }

    func sendMessage(message: String) {
        let currTime = LobbyUtils.getTS()
        locationRef.childByAutoId().setValue([
            "message": message,
            "localTime": currTime,
            "serverTime": ServerValue.timestamp()
        ])
    }

    private func listen() {
        locationRef.observe(.childAdded) { snapshot in
            guard
                let keyvals = snapshot.value as? [String: Any],
                let sendTime = keyvals["localTime"],
                let serverTime = keyvals["serverTime"]
            else {
                return
            }

            print("received: \(sendTime) -> \(serverTime) -> \(LobbyUtils.getTS())")
        }
    }

}
