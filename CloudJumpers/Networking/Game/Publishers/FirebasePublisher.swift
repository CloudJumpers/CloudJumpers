//
//  FirebasePublisher.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation
import FirebaseDatabase

class FirebasePublisher: RealtimePublisher {
    private let gameReference: DatabaseReference

    init(_ channelId: NetworkID) {
        self.gameReference = Database
            .database()
            .reference(withPath: GameKeys.root)
            .child(channelId)
    }

    func publishGameEventCommand(_ command: GameEventCommand) {
        gameReference.childByAutoId().setValue([
            GameKeys.source: command.source,
            GameKeys.sourceIsRecipient: command.isSourceRecipient ?? false,
            GameKeys.payload: command.payload,
            GameKeys.registeredAt: ServerValue.timestamp()
        ])
    }
}
