//
//  RespawnEffectEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/1/22.
//

import SpriteKit

class RespawnEffectEvent: SharedEvent {

    var isSharing: Bool
    var isExecutedLocally: Bool

    var timestamp: TimeInterval

    var entityID: EntityID
    var originalPosition: CGPoint

    init(onEntityWith id: EntityID,
         at originalPosition: CGPoint,
         isSharing: Bool = false,
         isExecutedLocally: Bool = true) {
        timestamp = EventManager.timestamp
        self.entityID = id
        self.originalPosition = originalPosition
        self.isSharing = isSharing
        self.isExecutedLocally = isExecutedLocally
    }

    init(onEntityWith id: EntityID,
         at timestamp: TimeInterval,
         at originalPosition: CGPoint,
         isSharing: Bool = false,
         isExecutedLocally: Bool = true) {
        self.entityID = id
        self.timestamp = timestamp
        self.originalPosition = originalPosition
        self.isSharing = isSharing
        self.isExecutedLocally = isExecutedLocally
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return nil }

        // Character effect
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.1)

        let respawnEffect = SKAction.repeat(SKAction.sequence([fadeIn, fadeOut]), count: 10)
        spriteComponent.node.run(respawnEffect)

        return nil
    }

    func getSharedCommand() -> GameEventCommand {
        let onlineUpdate = OnlineRespawnEvent(positionX: originalPosition.x, positionY: originalPosition.y)
        return RespawnEffectEventCommand(sourceId: entityID, event: onlineUpdate)
    }
}
