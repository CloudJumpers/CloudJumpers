//
//  MoveEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 25/3/22.
//

import Foundation
import CoreGraphics

struct MoveEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let displacement: CGVector

    init(on entity: Entity, by displacement: CGVector) {
        timestamp = EventManager.timestamp
        entityID = entity.id
        self.displacement = displacement
    }

    init(_ id: EntityID, _ timestamp: TimeInterval, by displacement: CGVector) {
        self.entityID = id
        self.timestamp = timestamp
        self.displacement = displacement
    }

    func execute(in entityManager: EntityManager) {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return }

        spriteComponent.node.position += CGVector(dx: displacement.dx, dy: 0)
    }
}
