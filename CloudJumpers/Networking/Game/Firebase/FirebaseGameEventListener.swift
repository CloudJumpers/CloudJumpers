//
//  FirebaseGameEventListener.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation
import FirebaseDatabase

class FirebaseGameEventListener: GameEventListener {
    private let gameReference: DatabaseReference
    weak var eventManager: EventManager?

    init(_ channelId: EntityID) {
        self.gameReference = Database
            .database()
            .reference(withPath: GameKeys.root)
            .child(channelId)

        setupListener()
    }

    deinit {
        gameReference.removeAllObservers()
    }

    private func setupListener() {
        gameReference.observe(.childAdded) { snapshot in
            print("Snapshot \(snapshot.value)")

            guard
                let body = snapshot.value as? [String: Any],
                let source = body[GameKeys.source] as? EntityID,
                let recipients = body[GameKeys.recipients] as? [EntityID]?,
                let payload = body[GameKeys.payload] as? String,
                let manager = self.eventManager,
                DefaultCommand(sourceId: source, recipients: recipients, payload: payload).processEvent(manager)
            else {
                return
            }
        }
    }
}
