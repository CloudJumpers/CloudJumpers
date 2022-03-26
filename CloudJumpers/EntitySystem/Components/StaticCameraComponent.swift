//
//  StaticCameraComponent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 26/3/22.
//

import Foundation

class StaticCameraComponent: Component {
    let id: ComponentID
    unowned var entity: Entity?

    init() {
        id = EntityManager.newComponentID
    }
}
