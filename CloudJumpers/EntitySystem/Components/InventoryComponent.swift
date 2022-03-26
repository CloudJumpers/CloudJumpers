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

    var inventory: [EntityID]

    init() {
        id = EntityManager.newComponentID
        inventory = []
    }

    func dequeue() -> EntityID? {
        guard !inventory.isEmpty else {
            return nil
        }

        let entityId = inventory[0]
        self.inventory.remove(at: 0)

        return entityId
    }

}
