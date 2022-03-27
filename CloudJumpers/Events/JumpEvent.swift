//
//  JumpEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 25/3/22.
//

import Foundation
import SpriteKit

struct JumpEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    init(on entity: Entity) {
        timestamp = EventManager.timestamp
        entityID = entity.id
    }

    func execute(in entityManager: EntityManager) {
        guard let entity = entityManager.entity(with: entityID),
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return }

        guard !isJumping(body: physicsComponent.body) else {
            return
        }
        physicsComponent.body.applyImpulse(Constants.jumpImpulse)
        if spriteComponent.node.action(forKey: "jumpCharacter") == nil {
          // if legs are not moving, start them
            let moveAnimation = SKAction.animate(with: Textures.character1.jumping,
                                                 timePerFrame: 0.3,
                                                 resize: false,
                                                 restore: true )
            spriteComponent.node.run(SKAction.repeatForever(moveAnimation), withKey: "jumpCharacter")
        }
    }

    private func isJumping(body: SKPhysicsBody) -> Bool {
        abs(body.velocity.dy) > Constants.jumpYTolerance
    }
}
