//
//  PowerUpEffectStartEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 10/4/22.
//

import Foundation
import SpriteKit

struct PowerUpEffectStartEvent: Event {
    var timestamp: TimeInterval
    var entityID: EntityID
    var powerUpId: EntityID

    var location: CGPoint

    init(by id: EntityID, location: CGPoint, powerUpId: EntityID, at timestamp: TimeInterval) {
        self.entityID = id
        self.location = location
        self.powerUpId = powerUpId
        self.timestamp = timestamp
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let entity = target.entity(with: powerUpId),
              entity is PowerUp,
              let powerUpSystem = target.system(ofType: PowerUpSystem.self)
        else { return }

        powerUpSystem.activatePowerUp(powerUpId, at: location)

    }
}
