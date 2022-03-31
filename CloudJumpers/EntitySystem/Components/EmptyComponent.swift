//
//  EmptyComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 31/3/22.
//

class EmptyComponent: Component {
    let id: ComponentID
    unowned var entity: Entity?

    init() {
        id = EntityManager.newEntityID
    }
}
