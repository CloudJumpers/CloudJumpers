//
//  FirebaseEmulator.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 8/4/22.
//

import Foundation
import FirebaseDatabase

class FirebaseEmulator: SimulatedSubscriber {
    private var gameReference: DatabaseReference?
    private var releaseTimer: Timer?

    weak var eventManager: EventManager?

    init() { }

    deinit {
        gameReference?.removeAllObservers()
    }

    func initialize(_ channelId: NetworkID) {
        self.gameReference = Database
            .database()
            .reference(withPath: GameKeys.root)
            .child(channelId)

        fetchCommands()
    }

    private func fetchCommands() {
        gameReference?.observeSingleEvent(of: .value) { snapshot in
            print("SUBSCRIBE fetch = \(snapshot)")
        }
    }

    private func setUpReleaseTimer() {

    }
}
