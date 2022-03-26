//
//  EventManager.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/19/22.
//

import Foundation

class EventManager {
    private typealias EventQueue = PriorityQueue<Event>

    private var events: EventQueue

    private var gameEventListener: GameEventListener?
    private var gameEventDispatcher: GameEventDispatcher?

    private var tempTimer: Timer?

    init(channel: NetworkID?) {
        events = EventQueue { $0.timestamp < $1.timestamp }

        if let channel = channel {
            gameEventListener = FirebaseGameEventListener(channel)
            gameEventDispatcher = FirebaseGameEventDispatcher(channel)
            gameEventListener?.eventManager = self
        }

        // TODO: This is just a hardcoded way to create positional updates
        tempTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            guard let userId = AuthService().getUserId() else {
                return
            }

            let event = FutureMovementEvent(positionX: 10.0, positionY: 10.0, action: "networkmove")
            let cmd = PositionalUpdateCommand(sourceId: userId, futureMovementEvent: event)
            self?.gameEventDispatcher?.dispatchGameEventCommand(cmd)
        })
    }

    deinit {
        tempTimer?.invalidate()
    }

    static var timestamp: TimeInterval {
        Date().timeIntervalSince1970
    }

    func add(_ event: Event) {
        events.enqueue(event)
    }

    func executeAll(in entityManager: EntityManager) {
        while let event = events.dequeue() {
            event.execute(in: entityManager)
        }
    }
}
