//
//  SwapMoveEffector.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 3/4/22.
//

import CoreGraphics

struct SwapMoveEffector: Effector {
    let entityID: EntityID

    init(on entity: Entity) {
        entityID = entity.id
    }

    func apply(to event: Event) -> Event {
        guard let event = event as? MoveEvent else {
            return event
        }

        let swappedDisplacement = CGVector(
            dx: -event.displacement.dx,
            dy: -event.displacement.dy)

        return MoveEvent(onEntityWith: event.entityID, at: event.timestamp, by: swappedDisplacement)
    }

    func shouldDetach(in entityManager: EntityManager) -> Bool {
        // TODO: - Add timer logic here
        false
    }
}
