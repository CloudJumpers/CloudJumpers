//
//  ObtainEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 26/3/22.
//

import Foundation

struct OldObtainEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let otherEntityID: EntityID

    init(on entityID: EntityID, obtains otherEntityID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
        self.otherEntityID = otherEntityID
    }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        guard let entity = entityManager.entity(with: entityID),
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity),
              let otherEntity = entityManager.entity(with: otherEntityID),
              let ownerComponent = entityManager.component(ofType: OwnerComponent.self, of: otherEntity),
              ownerComponent.ownerEntityId == nil
        else { return }

        // TODO: Handle this in contact handler @ERIC
        if physicsComponent.body.categoryBitMask == Constants.bitmaskPlayer,
           let inventoryComponent = entityManager.component(ofType: InventoryComponent.self, of: entity) {
            inventoryComponent.inventory.enqueue(otherEntityID)
            ownerComponent.ownerEntityId = entityID
            return
        }

        supplier.add(RemoveEntityEvent(otherEntityID, timestamp: timestamp))
    }
}
