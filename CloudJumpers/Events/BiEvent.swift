//
//  BiEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 31/3/22.
//

import Foundation

struct BiEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let event1: Event
    private let event2: Event

    init(_ event1: Event, _ event2: Event) {
        timestamp = event1.timestamp
        entityID = event1.entityID
        self.event1 = event1
        self.event2 = event2
    }

    func shouldExecute(in entityManager: EntityManager) -> Bool {
        event1.shouldExecute(in: entityManager)
    }

    func execute(in entityManager: EntityManager) {
        event1.execute(in: entityManager)
        event2.execute(in: entityManager)
    }
}
