//
//  InventoryComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 26/3/22.
//

import Foundation

class InventoryComponent: Component {
    let id: ComponentID
    unowned var entity: Entity?

    var isUpdated = false
    var inventory: [EntityID]

    init() {
        id = EntityManager.newComponentID
        inventory = []
    }

    func enqueue(entityID: EntityID) {
        inventory.append(entityID)
        isUpdated = true
    }

    func dequeue() -> EntityID? {
        guard !inventory.isEmpty else {
            return nil
        }

        isUpdated = true

        let entityId = inventory[0]
        self.inventory.remove(at: 0)

        return entityId
    }

}
