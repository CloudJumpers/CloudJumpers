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

        if isPlayerChangingLocation(nodeA: nodeA, nodeB: nodeB) {
            metaDataDelegate?.metaData(changePlayerLocation: idA, location: idB)
        } else if isPlayerChangingLocation(nodeA: nodeB, nodeB: nodeA) {
            metaDataDelegate?.metaData(changePlayerLocation: idB, location: idA)
        }
    }

    func resolveEndContact(contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node,
              let idA = nodeA.entityID,
              let idB = nodeB.entityID

        else {
            return
        }

        if isPlayerChangingLocation(nodeA: nodeA, nodeB: nodeB) {
            metaDataDelegate?.metaData(changePlayerLocation: idA, location: nil)
        } else if isPlayerChangingLocation(nodeA: nodeB, nodeB: nodeA) {
            metaDataDelegate?.metaData(changePlayerLocation: idB, location: nil)
        }
    }

    func isPlayerChangingLocation(nodeA: SKNode, nodeB: SKNode) -> Bool {
        let nodeABitMask = nodeA.physicsBody?.categoryBitMask
        let nodeBBitMask = nodeB.physicsBody?.categoryBitMask

        return nodeABitMask == Constants.bitmaskPlayer
        && (nodeBBitMask == Constants.bitmaskPlatform || nodeBBitMask == Constants.bitmaskCloud)
        && isPlayerOnPlatform(player: nodeA, platform: nodeB)
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
