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

        print(nodeA)
        print(nodeB)

        if isPlayerChangingLocation(nodeA: nodeA, nodeB: nodeB) {
            metaDataDelegate?.metaData(changePlayerLocation: idA, location: idB)
        } else if isPlayerChangingLocation(nodeA: nodeB, nodeB: nodeA) {
            metaDataDelegate?.metaData(changePlayerLocation: idB, location: idA)
        }

        if isPlayerObtainingPowerUp(nodeA: nodeA, nodeB: nodeB) {
            eventManager?.add(ObtainEvent(on: idA, obtains: idB))
        } else if isPlayerObtainingPowerUp(nodeA: nodeB, nodeB: nodeA) {
            eventManager?.add(ObtainEvent(on: idB, obtains: idA))
        }

        if isDisasterHitting(nodeA: nodeA) {
            eventManager?.add(DisasterHitEvent(from: idA, on: idB))
        } else if isDisasterHitting(nodeA: nodeB) {
            eventManager?.add(DisasterHitEvent(from: idB, on: idA))
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

        return (nodeABitMask == Constants.bitmaskPlayer || nodeABitMask == Constants.bitmaskGuest)
        && (nodeBBitMask == Constants.bitmaskPlatform || nodeBBitMask == Constants.bitmaskCloud)
        && isPlayerOnPlatform(player: nodeA, platform: nodeB)
    }

    private func isPlayerOnPlatform(player: SKNode, platform: SKNode) -> Bool {
        let playerPosition = player.position
        let platformPosition = platform.position

        let platformTopLeftX = platformPosition.x - platform.frame.size.width / 2
        let platformTopRightX = platformPosition.x + platform.frame.size.width / 2
        let platformY = platformPosition.y

        return playerPosition.x > platformTopLeftX - player.frame.size.width / 2 &&
        playerPosition.x < platformTopRightX + player.frame.size.width / 2 &&
        playerPosition.y > platformY
    }

    private func isPlayerObtainingPowerUp(nodeA: SKNode, nodeB: SKNode) -> Bool {
        let nodeABitMask = nodeA.physicsBody?.categoryBitMask
        let nodeBBitMask = nodeB.physicsBody?.categoryBitMask

        return (nodeABitMask == Constants.bitmaskPlayer || nodeABitMask == Constants.bitmaskGuest)
        && nodeBBitMask == Constants.bitmaskPowerUp
    }

    private func isDisasterHitting(nodeA: SKNode) -> Bool {
        let nodeABitMask = nodeA.physicsBody?.categoryBitMask
        return nodeABitMask == Constants.bitmaskDisaster
    }
}
