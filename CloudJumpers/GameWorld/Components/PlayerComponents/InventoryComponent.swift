//
//  InventoryComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 26/3/22.
//

class InventoryComponent: Component {
    typealias Inventory = Queue<EntityID>

    var inventory: Inventory

    override init() {
        inventory = Inventory()
        super.init()
    }
}
