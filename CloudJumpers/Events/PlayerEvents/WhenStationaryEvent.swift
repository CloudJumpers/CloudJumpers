//
//  WhenStationaryEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

import Foundation

struct WhenStationaryEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let event: Event

    init(_ entityID: EntityID, do event: Event) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
        self.event = event
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let physicsSystem = target.system(ofType: PhysicsSystem.self),
              !physicsSystem.isMoving(entityID)
        else { return }

        supplier.add(event)
    }
}
