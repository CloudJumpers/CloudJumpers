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

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return nil }

        // Character effect
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.25)
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.25)

        let respawnEffect = SKAction.repeat(SKAction.sequence([fadeOut, fadeIn]), count: 8)

        spriteComponent.node.run(respawnEffect)

        return nil
    }
}
