//
//  RespawnEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/30/22.
//

import Foundation

class RespawnEvent: Event {
    var timestamp: TimeInterval
    
    var entityID: EntityID
    
    init(onEntityWith id: EntityID, at timestamp: TimeInterval) {
        self.entityID = id
        self.timestamp = timestamp
    }
    
    func execute(in entityManager: EntityManager) {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return }

        spriteComponent.node.position = Constants.playerInitialPosition
    }
}
