//
//  ContactResolver.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/19/22.
//

import SpriteKit

class ContactResolver {
    weak var entitiesManager: EntitiesManager?

    var eventManager: EventManager

    init(entitiesManager: EntitiesManager, eventManager: EventManager) {
        self.entitiesManager = entitiesManager
        self.eventManager = eventManager
    }

    func resolveBeginContact(contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
//              let entityA = entitiesManager?.getEntity(of: nodeA),
//              let entityB = entitiesManager?.getEntity(of: nodeB)
        else {
            return
        }
        // Need to handle this properly

        let nodeABitMask = nodeA.physicsBody?.categoryBitMask
        let nodeBBitMask = nodeB.physicsBody?.categoryBitMask

        if (nodeABitMask == Constants.bitmaskPlayer && nodeBBitMask == Constants.bitmaskPlatform) ||
        (nodeABitMask == Constants.bitmaskPlatform && nodeBBitMask == Constants.bitmaskPlayer) {
            eventManager.eventsQueue.append(Event(type: .gameEnd))
        }

    }

    func resolveEndContact(contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node,
              let entityA = entitiesManager?.getEntity(of: nodeA),
              let entityB = entitiesManager?.getEntity(of: nodeB)
        else {
            return
        }
        // Do nothing for now
    }
}
