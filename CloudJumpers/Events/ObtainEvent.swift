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

    init(on entity: Entity, obtains otherEntity: Entity) {
        timestamp = EventManager.timestamp
        entityID = entity.id
        otherEntityID = otherEntity.id
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard let entity = entityManager.entity(with: entityID),
              let inventoryComponent = entityManager.component(ofType: InventoryComponent.self, of: entity)
        else { return nil }

        inventoryComponent.inventory.insert(otherEntityID)

        return nil
    }
}
