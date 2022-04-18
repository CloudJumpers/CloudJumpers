//
//  FirebaseEmulator.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 8/4/22.
//

import Foundation
import FirebaseDatabase

class FirebaseEmulator: GameEventSubscriber {
    private var storedCommands: [(timeDeltaSeconds: Double, command: GameEventCommand)]
    private var hasReleaseStarted: Bool

    private var gameReference: DatabaseReference?
    private var releaseTimer: Timer?

    weak var eventManager: EventManager? { didSet { self.startEventReplay() } }

    init() {
        self.storedCommands = []
        self.hasReleaseStarted = false
    }

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

    private func startEventReplay() {
        guard !storedCommands.isEmpty, eventManager != nil, !hasReleaseStarted else {
            eventManager?.add(OpacityChangeEvent(on: GameConstants.shadowPlayerID, opacity: .zero))
            return
        }

        hasReleaseStarted = true
        eventManager?.add(OpacityChangeEvent(on: GameConstants.shadowPlayerID, opacity: 1.0))
        eventManager?.add(DisastersToggleEvent(false))
        releaseNextEvent()
    }

    private func fetchCommands() {
        gameReference?.observeSingleEvent(of: .value) { snapshot in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }

            var prevTime: Double?

            for snap in snapshots {
                guard
                    let body = snap.value as? [String: Any],
                    let payload = body[GameKeys.payload] as? String,
                    let registeredAt = body[GameKeys.registeredAt] as? Double
                else {
                    return
                }

                let deltaMillis = registeredAt - (prevTime ?? (registeredAt - LifecycleConstants.pollInterval))
                prevTime = registeredAt

                let command = DefaultCommand(GameConstants.shadowPlayerID, payload)
                self.storedCommands.append((timeDeltaSeconds: deltaMillis / 1_000, command: command))
            }

            self.startEventReplay()
        }
    }

    private func releaseNextEvent() {
        guard !storedCommands.isEmpty else {
            return
        }

        var first = storedCommands.removeFirst()

        releaseTimer = Timer.scheduledTimer(withTimeInterval: first.timeDeltaSeconds, repeats: false) { [weak self] _ in
            guard let manager = self?.eventManager else {
                return
            }

            assert(first.command.unpackIntoEventManager(manager))
            self?.releaseNextEvent()
        }
    }
}
