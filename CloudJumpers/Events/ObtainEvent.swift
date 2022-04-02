//
//  ObtainEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 26/3/22.
//

import Foundation

struct ObtainEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let otherEntityID: EntityID

    init(on entityID: EntityID, obtains otherEntityID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
        self.otherEntityID = otherEntityID
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard let entity = entityManager.entity(with: entityID),
              let inventoryComponent = entityManager.component(ofType: InventoryComponent.self, of: entity),
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity),
              let otherEntity = entityManager.entity(with: otherEntityID),
              let ownerComponent = entityManager.component(ofType: OwnerComponent.self, of: otherEntity),
              ownerComponent.ownerEntityId == nil
        else { return nil }

        if physicsComponent.body.categoryBitMask == Constants.bitmaskPlayer {
            inventoryComponent.inventory.enqueue(otherEntityID)
            ownerComponent.ownerEntityId = entityID
        } else if physicsComponent.body.categoryBitMask == Constants.bitmaskGuest {
            return [RemoveEntityEvent(otherEntity)]
        }

        return nil
    }
}
