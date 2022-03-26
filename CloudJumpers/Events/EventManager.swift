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

    // TODO: This timer is just a hardcoded way to demonstrate creation of positional updates
    private var tempTimer: Timer?

    init(channel: NetworkID?) {
        events = EventQueue { $0.timestamp < $1.timestamp }
        subscribe(to: channel)
        setUpPeriodicOnlineMoveEventDispatchTimer()
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

    func dispatchGameEventCommand(_ command: GameEventCommand) {
        gameEventDispatcher?.dispatchGameEventCommand(command)
    }

    private func subscribe(to channel: NetworkID?) {
        guard let channel = channel else {
            return
        }

        gameEventListener = FirebaseGameEventListener(channel)
        gameEventDispatcher = FirebaseGameEventDispatcher(channel)
        gameEventListener?.eventManager = self
    }

    private func setUpPeriodicOnlineMoveEventDispatchTimer() {
        tempTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            guard let userId = AuthService().getUserId() else {
                return
            }

            let event = OnlineMoveEvent(displacementX: 10.0, displacementY: 10.0, action: "networkmove")
            let cmd = MoveEventCommand(sourceId: userId, event: event)
            self?.dispatchGameEventCommand(cmd)
        })
    }

    deinit {
        tempTimer?.invalidate()
    }
}
