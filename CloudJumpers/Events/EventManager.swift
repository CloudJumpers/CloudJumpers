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
        events = EventQueue(sort: Self.priority(_:_:))
        subscribe(to: channel)
    }

    static var timestamp: TimeInterval {
        Date().timeIntervalSince1970
    }

    func add(_ event: Event) {
        events.enqueue(event)
    }

    func executeAll(in entityManager: EntityManager) {
        var counter = events.count
        var deferredEvents: [Event] = []

        while counter > 0 {
            guard let event = events.dequeue() else {
                fatalError("EventManager.executeAll(in:) dequeued an empty EventQueue")
            }

            if event.shouldExecute(in: entityManager) {
                let nextEvents = event.execute(in: entityManager)
                nextEvents?.forEach(add(_:))
                counter += nextEvents?.count ?? 0
            } else {
                deferredEvents.append(event)
            }

            counter -= 1
        }

        deferredEvents.forEach(add(_:))
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

    private static func priority(_ event1: Event, _ event2: Event) -> Bool {
        guard let rank1 = Events.type(of: event1)?.rawValue,
              let rank2 = Events.type(of: event2)?.rawValue
        else { fatalError("An Event was not registered in Events enum") }

        if rank1 != rank2 {
            return rank1 < rank2
        } else {
            return event1.timestamp < event2.timestamp
        }
    }
}
