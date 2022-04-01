//
//  RespawnEffectEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/1/22.
//

import Foundation
import SpriteKit

class RespawnEffectEvent: Event {
    var timestamp: TimeInterval
    
    var entityID: EntityID
    
    init(onEntityWith id: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = id
    }

    init(onEntityWith id: EntityID, at timestamp: TimeInterval) {
        self.entityID = id
        self.timestamp = timestamp
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return nil }
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
        let fadeIn =  SKAction.fadeAlpha(to: 1, duration: 0.1)
        
        let respawnEffect = SKAction.repeat(SKAction.sequence([fadeIn,fadeOut]), count: 10)
        spriteComponent.node.run(respawnEffect)

        return nil
    }
}
