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

    init(on entityID: EntityID, location: CGPoint) {
        timestamp = EventManager.timestamp
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
            activatePowerUpId: powerUpComponent.kind.name))

    }

}
