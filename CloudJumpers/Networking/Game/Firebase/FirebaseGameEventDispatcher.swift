//
//  FirebaseGameEventDispatcher.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation
import FirebaseDatabase

class FirebaseGameEventDispatcher: GameEventDispatcher {
    private let gameReference: DatabaseReference

    init(_ channelId: EntityID) {
        self.gameReference = Database
            .database()
            .reference(withPath: GameKeys.root)
            .child(channelId)
    }

    func dispatchGameEventCommand(_ command: GameEventCommand) {
        gameReference.childByAutoId().setValue([
            GameKeys.source: command.source,
            GameKeys.recipients: command.recipients ?? [],
            GameKeys.payload: command.payload,
            GameKeys.registeredAt: ServerValue.timestamp()
        ])
    }
}
