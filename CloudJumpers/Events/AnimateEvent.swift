//
//  AnimateEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 26/3/22.
//

import Foundation

struct OldAnimateEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let kind: Textures.Kind

    init(on entity: Entity, to kind: Textures.Kind) {
        timestamp = EventManager.timestamp
        entityID = entity.id
        self.kind = kind
    }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        guard let entity = entityManager.entity(with: entityID),
              let animationComponent = entityManager.component(ofType: AnimationComponent.self, of: entity)
        else { return }

        animationComponent.kind = kind
    }
}
