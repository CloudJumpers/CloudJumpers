//
//  Component.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

typealias ComponentID = String

class Component {
    let id: ComponentID
    unowned var entity: Entity?

    init() {
        id = EntityManager.newComponentID
    }
}
