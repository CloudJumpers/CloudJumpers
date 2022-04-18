//
//  SlowJumpEffector.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 15/4/22.
//

import Foundation
import CoreGraphics

struct SlowJumpEffector: Effector {
    let entityID: EntityID

    private let effectEntity: Entity

    init(on entity: Entity, watching effectEntity: Entity) {
        entityID = entity.id
        self.effectEntity = effectEntity
    }

    func apply(to event: Event) -> Event {
        guard let event = event as? JumpEvent else {
            return event
        }

        return JumpEvent(
            onEntityWith: event.entityID,
            by: PhysicsConstants.jumpImpulse / 3,
            at: event.timestamp)
    }

    func shouldDetach(in target: EventModifiable) -> Bool {
        guard let effectorDetachSystem = target.system(ofType: EffectorDetachSystem.self) else {
            return false
        }

        return effectorDetachSystem.shouldDetach(watchingEntity: effectEntity)
    }
}
