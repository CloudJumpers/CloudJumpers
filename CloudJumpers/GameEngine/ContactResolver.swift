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
              let nodeB = contact.bodyB.node,
              let entityA = entitiesManager?.getEntity(of: nodeA) as? PlayerEntity,
              let entityB = entitiesManager?.getEntity(of: nodeB) as? PlatformEntity
        else {
            return
        }
        // Need to handle this properly
        eventManager.eventsQueue.append(Event(type: .gameEnd))

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
