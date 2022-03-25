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

    init() {
        events = EventQueue { $0.timestamp < $1.timestamp }
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

    func publish(_ event: Event) {
        // TODO: @rssujay Serialise and publish Event here
    }

    func subscribe() {
        // TODO: @rssujay Initialise network subscriber here
    }
}
