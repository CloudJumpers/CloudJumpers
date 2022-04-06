//
//  FirebaseSubscriber.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation
import FirebaseDatabase

class FirebaseSubscriber: GameEventSubscriber {
    private let gameReference: DatabaseReference
    weak var eventManager: EventManager?

    init(_ channelId: NetworkID) {
        self.gameReference = Database
            .database()
            .reference(withPath: GameKeys.root)
            .child(channelId)

        setupListener()
    }

    deinit {
        gameReference.removeAllObservers()
    }

    /// https://stackoverflow.com/questions/25536547/how-do-i-get-a-server-timestamp-from-firebases-ios-api
    /// Creating items with a server timestamp will trigger listeners twice:
    /// on childAdded will be triggered on local creation
    /// on childChanged will be triggered on remote creation
    /// Since we're interested in only remote creation time, on the device
    /// generating the update, we filter out self updates via onChildAdded.
    private func setupListener() {
        gameReference.observe(.childAdded) { snapshot in
            guard
                let userId = AuthService().getUserId(),
                let body = snapshot.value as? [String: Any],
                let source = body[GameKeys.source] as? NetworkID,
                source != userId,
                let payload = body[GameKeys.payload] as? String,
                let manager = self.eventManager,
                DefaultCommand(source, payload).unpackIntoEventManager(manager)
            else {
                return
            }
        }

        gameReference.observe(.childChanged) { snapshot in
            guard
                let userId = AuthService().getUserId(),
                let body = snapshot.value as? [String: Any],
                let source = body[GameKeys.source] as? NetworkID,
                let sourceIsRecipient = body[GameKeys.sourceIsRecipient] as? Bool,
                source == userId && sourceIsRecipient,
                let payload = body[GameKeys.payload] as? String,
                let manager = self.eventManager,
                DefaultCommand(source, payload).unpackIntoEventManager(manager)
            else {
                return
            }
        }
    }
}
