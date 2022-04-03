//
//  RemoveUnboundEntityEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 1/4/22.
//

import Foundation
import CoreGraphics

struct RemoveUnboundEntityEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    init(_ entity: Entity) {
        timestamp = EventManager.timestamp
        entityID = entity.id
    }

    func shouldExecute(in entityManager: EntityManager) -> Bool {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return false }

        return Self.isPositionOutOfBound(spriteComponent.node.position)
    }

    func execute(in entityManager: EntityManager) ->(localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? {
        entityManager.remove(withID: entityID)
        return nil
    }

    private static func isPositionOutOfBound(_ position: CGPoint) -> Bool {
        position.x < Constants.minOutOfBoundX || position.x > Constants.maxOutOfBoundX
    }
}
