//
//  ObtainEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation

struct ObtainEvent: Event {

    let timestamp: TimeInterval
    let entityID: EntityID

    private let otherEntityID: EntityID

    init(on entityID: EntityID, obtains otherEntityID: EntityID, timestamp: TimeInterval = EventManager.timestamp) {
        self.entityID = entityID
        self.otherEntityID = otherEntityID
        self.timestamp = timestamp
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        // TODO: Fix this after done with contact handler

    }
}
