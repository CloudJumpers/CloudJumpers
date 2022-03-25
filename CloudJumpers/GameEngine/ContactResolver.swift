//
//  ContactResolver.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/19/22.
//

import SpriteKit

class ContactResolver {
    weak var metaDataDelegate: GameMetaDataDelegate?
    unowned var eventManager: EventManager?

    init(to eventManager: EventManager) {
        self.eventManager = eventManager
    }

    func resolveBeginContact(contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node,
              let idA = nodeA.entityID,
              let idB = nodeB.entityID
        else {
            return
        }
        // Really need to handle this properly

        // ???: Need to handle this properly
        let nodeABitMask = nodeA.physicsBody?.categoryBitMask
        let nodeBBitMask = nodeB.physicsBody?.categoryBitMask

        if nodeABitMask == Constants.bitmaskPlayer
            && nodeBBitMask == Constants.bitmaskPlatform
            && isPlayerOnPlatform(player: nodeA, platform: nodeB) {
            metaDataDelegate?.metaData(changePlayerLocation: idA, location: idB)
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
