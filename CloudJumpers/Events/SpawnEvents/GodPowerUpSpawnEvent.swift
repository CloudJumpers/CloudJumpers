//
//  GodPowerUpSpawnEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/18/22.
//

import Foundation
import CoreGraphics

struct GodPowerUpSpawnEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private var position: CGPoint
    private var type: PowerUpComponent.Kind
    private var powerUpID: EntityID

    init(entityID: EntityID,
         position: CGPoint,
         type: PowerUpComponent.Kind,
         powerUpID: EntityID,
         at timestamp: TimeInterval = EventManager.timestamp) {
        self.entityID = entityID
        self.powerUpID = powerUpID
        self.position = position
        self.timestamp = timestamp
        self.type = type
     }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        supplier.add(PowerUpSpawnEvent(position: position, type: type, entityId: powerUpID)
            .then(do: ObtainEvent(on: entityID, obtains: powerUpID)))
    }
}
