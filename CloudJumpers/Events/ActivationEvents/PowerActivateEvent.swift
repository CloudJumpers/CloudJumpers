//
//  PowerActivateEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

class PowerActivateEvent: Event {

    let timestamp: TimeInterval
    let entityID: EntityID

    private let location: CGPoint

    init(by entityID: EntityID, location: CGPoint, at timestamp: TimeInterval = EventManager.timestamp) {
        self.timestamp = timestamp
        self.entityID = entityID
        self.location = location
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let system = target.system(ofType: InventorySystem.self),
              let powerUpID = system.dequeuePowerUp(for: entityID),
              let powerUp = target.entity(with: powerUpID)
        else {
            return
        }

        target.remove(powerUp)

        supplier.add(ExternalPowerUpStartEvent(
            activatePowerUpPositionX: location.x,
            activatePowerUpPositionY: location.y,
            activatePowerUpId: powerUpID))

    }

}
