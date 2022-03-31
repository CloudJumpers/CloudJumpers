//
//  InventoryComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 26/3/22.
//

class InventoryComponent: Component {
    typealias Inventory = Queue<EntityID>

    let id: ComponentID
    unowned var entity: Entity?

    var inventory: Inventory

    init() {
        id = EntityManager.newComponentID
        inventory = Inventory()
    }
}
