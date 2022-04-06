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
    private var effectors: [Effector]

    private var gameEventListener: GameEventSubscriber?
    private var gameEventDispatcher: GameEventPublisher?

    init(channel: NetworkID?) {
        events = EventQueue(sort: Self.priority(_:_:))
        effectors = []
        subscribe(to: channel)
    }

    static var timestamp: TimeInterval {
        Date().timeIntervalSince1970
    }

    func add(_ event: Event) {
        events.enqueue(event)
    }

    func add(_ effector: Effector) {
        effectors.append(effector)
    }

    func executeAll(in entityManager: EntityManager) {
        validateEffectors(in: entityManager)

        var counter = events.count
        var deferredEvents: [Event] = []

        while counter > 0 {
            guard var event = events.dequeue() else {
                fatalError("EventManager.executeAll(in:) dequeued an empty EventQueue")
            }

            if event.shouldExecute(in: entityManager) {
                event = transformEvent(event)

                var supplier = Supplier()
                event.execute(in: entityManager, thenSuppliesInto: &supplier)
                let newEventsCount = supply(from: supplier)

                counter += newEventsCount
            } else {
                deferredEvents.append(event)
            }

            counter -= 1
        }

        deferredEvents.forEach(add(_:))
    }

    func dispatch(_ remoteEvent: RemoteEvent) {
        guard
            let command = remoteEvent.createDispatchCommand(),
            let dispatcher = gameEventDispatcher
        else {
            return
        }

        dispatcher.publishGameEventCommand(command)
    }

    private func subscribe(to channel: NetworkID?) {
        guard let channel = channel else {
            return
        }

        gameEventListener = RealtimeSubscriber(channel)
        gameEventDispatcher = FirebasePublisher(channel)
        gameEventListener?.eventManager = self
    }

    private static func priority(_ event1: Event, _ event2: Event) -> Bool {
        guard let rank1 = Events.rank(of: event1),
              let rank2 = Events.rank(of: event2)
        else { fatalError("""
            One or more Events were not registered in Events enum
            \(String(describing: type(of: event1))) -> \(String(describing: Events.rank(of: event1)))
            \(String(describing: type(of: event2))) -> \(String(describing: Events.rank(of: event2)))
            """) }

        if rank1 != rank2 {
            return rank1 < rank2
        } else {
            return event1.timestamp < event2.timestamp
        }
    }

    private func supply(from supplier: Supplier) -> Int {
        supplier.events.forEach(add(_:))
        supplier.remoteEvents.forEach(dispatch(_:))
        supplier.effectors.forEach(add(_:))
        return supplier.events.count
    }

    private func validateEffectors(in entityManager: EntityManager) {
        effectors.removeAll { $0.shouldDetach(in: entityManager) }
    }

    private func transformEvent(_ event: Event) -> Event {
        var event = event
        for effector in effectors {
            event = effector.apply(to: event)
        }

        return event
    }
}
