//
//  FirebaseEmulator.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 8/4/22.
//

import Foundation
import FirebaseDatabase

class FirebaseShadowPlayerEmulator: GameEventEmulator {
    private var storedCommands: [(timeDeltaSeconds: Double, command: GameEventCommand)] = []
    private(set) var hasReplayStarted = false

    private var gameReference: DatabaseReference?
    private var releaseTimer: Timer?

    weak var eventManager: EventManager? { didSet { self.startEventReplay() } }

    deinit {
        gameReference?.removeAllObservers()
    }

    func replayEventsFrom(_ channelId: NetworkID) {
        self.gameReference = Database.database()
            .reference(withPath: GameKeys.root)
            .child(channelId)

        fetchCommands()
    }

    private func startEventReplay() {
        guard !storedCommands.isEmpty, eventManager != nil, !hasReplayStarted else {
            onFetchUnknown()
            return
        }

        onFetchSuccess()
        hasReplayStarted = true
        releaseNextEvent()
    }

    private func fetchCommands() {
        gameReference?.observeSingleEvent(of: .value) { snapshot in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }

            var prevTime: Double?

            for snap in snapshots {
                guard let body = snap.value as? [String: Any],
                      let payload = body[GameKeys.payload] as? String,
                      let registeredAt = body[GameKeys.registeredAt] as? Double
                else {
                    continue
                }

                let deltaMillis = registeredAt - (prevTime ?? (registeredAt - LifecycleConstants.pollInterval))
                prevTime = registeredAt
                self.createDeferredCommand(payload, after: deltaMillis)

            }

            self.startEventReplay()
        }
    }

    private func createDeferredCommand(_ payload: String, after deltaMillis: Double) {
        let command = DefaultCommand(GameConstants.shadowPlayerID, payload)
        self.storedCommands.append((timeDeltaSeconds: deltaMillis / 1_000, command: command))
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

    private func onFetchUnknown() {
        eventManager?.add(OpacityChangeEvent(on: GameConstants.shadowPlayerID, opacity: .zero))
    }

    private func onFetchSuccess() {
        eventManager?.add(OpacityChangeEvent(on: GameConstants.shadowPlayerID, opacity: 1.0))
        eventManager?.add(ShadowDisasterEffector(entityID: GameConstants.shadowPlayerID))
    }
}
