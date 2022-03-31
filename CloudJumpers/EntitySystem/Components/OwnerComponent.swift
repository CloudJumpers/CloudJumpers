//
//  OwnerComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 31/3/22.
//

class OwnerComponent: Component {
    let id: ComponentID
    unowned var entity: Entity?

    var ownerEntityId: EntityID?

    init(ownerEntityId: EntityID? = nil) {
        id = EntityManager.newEntityID
        self.ownerEntityId = ownerEntityId
    }
}
