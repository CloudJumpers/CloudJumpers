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

    var inventory: Set<EntityID>

    init() {
        id = EntityManager.newComponentID
        inventory = []
    }
}
