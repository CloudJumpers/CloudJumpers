//
//  ContactResolver.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/19/22.
//

import SpriteKit

class ContactResolver {
    weak var entitiesManager: EntitiesManager?
    weak var eventDelegate: EventDelegate?

    init(entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
    }

    func resolveBeginContact(contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
        else {
            return
        }
        // Need to handle this properly

        let nodeABitMask = nodeA.physicsBody?.categoryBitMask
        let nodeBBitMask = nodeB.physicsBody?.categoryBitMask

        if nodeABitMask == Constants.bitmaskPlayer && nodeBBitMask == Constants.bitmaskPlatform &&
            isPlayerOnPlatform(player: nodeA, platform: nodeB) {

            eventDelegate?.event(add: Event(type: .gameEnd))
        }

    }

    func resolveEndContact(contact: SKPhysicsContact) {
        // Do nothing for now
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
