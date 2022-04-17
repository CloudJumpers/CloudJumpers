//
//  SlowMoveEffector.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 15/4/22.
//

import Foundation
import CoreGraphics

struct SlowMoveEffector: Effector {
    let entityID: EntityID

    private let effectEntity: Entity

    init(on entity: Entity, watching effectEntity: Entity) {
        entityID = entity.id
        self.effectEntity = effectEntity
    }

    func apply(to event: Event) -> Event {
        guard let event = event as? MoveEvent else {
            return event
        }

        let slowedDisplacement = CGVector(
            dx: event.displacement.dx / 3,
            dy: event.displacement.dy / 3)

        return MoveEvent(onEntityWith: event.entityID, by: slowedDisplacement, at: event.timestamp)
    }

    func shouldDetach(in target: EventModifiable) -> Bool {
        guard let effectorDetachSystem = target.system(ofType: EffectorDetachSystem.self) else {
            return false
        }

        return effectorDetachSystem.shouldDetach(watchingEntity: effectEntity)
    }
}
