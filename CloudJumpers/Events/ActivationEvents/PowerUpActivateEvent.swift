//
//  PowerUpActivateEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 10/4/22.
//

import Foundation
import CoreGraphics

class PowerUpActivateEvent: Event {

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
              let powerUpID = system.dequeueItem(for: entityID),
              let powerUpSystem = target.system(ofType: PowerUpSystem.self)
        else { return }

        powerUpSystem.activatePowerUp(powerUpID, activatorId: entityID, at: location)
    }

}
