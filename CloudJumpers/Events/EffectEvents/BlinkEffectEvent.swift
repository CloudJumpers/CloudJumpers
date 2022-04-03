//
//  FadeEntityEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 2/4/22.
//

import SpriteKit

struct BlinkEffectEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private var duration: Double
    private var numberOfLoop: Int

    init(on id: EntityID, duration: Double, numberOfLoop: Int) {
        timestamp = EventManager.timestamp
        self.entityID = id
        self.duration = duration
        self.numberOfLoop = numberOfLoop

    }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return }

        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: duration)

        let respawnEffect = SKAction.repeat(SKAction.sequence([fadeOut, fadeIn]), count: numberOfLoop)

        spriteComponent.node.run(respawnEffect)
    }
}
