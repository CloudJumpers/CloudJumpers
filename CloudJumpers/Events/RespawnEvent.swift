//
//  RespawnEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/30/22.
//

import Foundation
import CoreGraphics

class RespawnEvent: Event {
    var timestamp: TimeInterval
    var position: CGPoint

    var entityID: EntityID
    init(onEntityWith id: EntityID, to position: CGPoint) {
        timestamp = EventManager.timestamp
        self.entityID = id
        self.position = position
    }

    init(onEntityWith id: EntityID, at timestamp: TimeInterval, to position: CGPoint) {
        self.entityID = id
        self.timestamp = timestamp
        self.position = position
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return nil }

        print("RESPAWN")

        spriteComponent.node.position = position

        return nil
    }
}
