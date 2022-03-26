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

    init(channel: NetworkID?) {
        events = EventQueue { $0.timestamp < $1.timestamp }
        subscribe(to: channel)
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
}
