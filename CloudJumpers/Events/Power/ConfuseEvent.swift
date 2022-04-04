//
//  ConfuseEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 3/4/22.
//

import Foundation

struct ConfuseEvent: Event {
    var timestamp: TimeInterval
    var entityID: EntityID

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        guard let activator = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: activator)
        else { return }

        let location = spriteComponent.node.position
    }
}
