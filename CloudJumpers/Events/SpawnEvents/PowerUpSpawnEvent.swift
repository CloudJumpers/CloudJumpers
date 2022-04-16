//
//  PowerUpSpawnEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/15/22.
//

import Foundation
import CoreGraphics

struct PowerUpSpawnEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private var position: CGPoint
    private var type: PowerUpComponent.Kind

    init(position: CGPoint,
         type: PowerUpComponent.Kind, entityId: EntityID,
         at timestamp: TimeInterval = EventManager.timestamp) {
        self.entityID = entityId
        self.position = position
        self.timestamp = timestamp
        self.type = type
     }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        let powerUp = PowerUp(type, at: position, with: entityID)
        target.add(powerUp)
    }
}
