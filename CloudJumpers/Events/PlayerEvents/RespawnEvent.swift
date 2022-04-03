//
//  RespawnEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/30/22.
//

import Foundation
import CoreGraphics

struct RespawnEvent: Event {
    var timestamp: TimeInterval
    var position: CGPoint

    var entityID: EntityID

    init(onEntityWith id: EntityID, to position: CGPoint) {
        self.entityID = id
        self.timestamp = EventManager.timestamp
        self.position = position
    }

    init(onEntityWith id: EntityID, at timestamp: TimeInterval, to position: CGPoint) {
        self.entityID = id
        self.timestamp = timestamp
        self.position = position
    }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return }

        spriteComponent.node.position = position
        let effectEvent = RespawnEffectEvent(onEntityWith: entityID, at: spriteComponent.node.position)

        supplier.add(effectEvent)
    }
}
