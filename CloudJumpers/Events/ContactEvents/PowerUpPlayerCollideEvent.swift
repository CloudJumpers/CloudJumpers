//
//  PowerUpPlayerCollideEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 3/4/22.
//

import Foundation

struct PowerUpPlayerCollideEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let powerUpEntityID: EntityID

    init(on entityID: EntityID, powerUp otherEntityID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
        self.powerUpEntityID = otherEntityID
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard target.entity(with: powerUpEntityID) != nil
        else { return }

        print("obtain")
        let externalObtainEntityEvent = ExternalObtainEntityEvent(obtainedEntityID: powerUpEntityID)
        supplier.add(externalObtainEntityEvent)
    }
}
