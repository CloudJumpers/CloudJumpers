//
//  RespawnEffectEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/1/22.
//

import SpriteKit

struct RespawnEffectEvent: Event {
    var timestamp: TimeInterval

    var entityID: EntityID
    var originalPosition: CGPoint

    init(onEntityWith id: EntityID, at originalPosition: CGPoint) {
        timestamp = EventManager.timestamp
        self.entityID = id
        self.originalPosition = originalPosition

    }

    init(onEntityWith id: EntityID, at timestamp: TimeInterval, at originalPosition: CGPoint) {
        self.entityID = id
        self.timestamp = timestamp
        self.originalPosition = originalPosition
    }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        // TODO: Add in explosion effect at original position
        supplier.add(BlinkEffectEvent(on: entityID, duration: 0.25, numberOfLoop: 8))
    }
}
