//
//  ContactResolver.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/19/22.
//

import SpriteKit

class ContactResolver {
    unowned var entityManager: EntityManager?
    unowned var eventManager: EventManager?

    init(to eventManager: EventManager, entityManager: EntityManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func resolveBeginContact(contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
        else { return }

        // ???: Need to handle this properly
        let nodeABitMask = nodeA.physicsBody?.categoryBitMask
        let nodeBBitMask = nodeB.physicsBody?.categoryBitMask

        if nodeABitMask == Constants.bitmaskPlayer &&
           nodeBBitMask == Constants.bitmaskPlatform &&
           isPlayerOnPlatform(player: nodeA, platform: nodeB) {
            // TODO: @jushg Handle game end
            // eventManager?.event(add: Event(type: .gameEnd))
        }
        
        if nodeABitMask == Constants.bitmaskPlayer &&
            nodeBBitMask == Constants.bitmaskPowerUp {
            
            guard let entityIDA = nodeA.entityID,
                  let entityIDB = nodeB.entityID,
                  let entityA = entityManager?.entity(with: entityIDA),
                  let entityB = entityManager?.entity(with: entityIDB) else {
                return
            }
            
            eventManager?.add(ObtainEvent(on: entityA, obtains: entityB))
        }
    }

    func resolveEndContact(contact: SKPhysicsContact) {
        // TODO: To be implemented
    }

    private func isPlayerOnPlatform(player: SKNode, platform: SKNode) -> Bool {
        let playerPosition = player.position
        let platformPosition = platform.position

        let platformTopLeftX = platformPosition.x - platform.frame.size.width / 2
        let platformTopRightX = platformPosition.x + platform.frame.size.width / 2
        let platformY = platformPosition.y

        return playerPosition.x > platformTopLeftX &&
        playerPosition.x < platformTopRightX &&
        playerPosition.y > platformY
    }
}
