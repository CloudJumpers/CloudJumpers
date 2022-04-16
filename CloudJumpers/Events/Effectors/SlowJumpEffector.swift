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

        return JumpEvent(onEntityWith: event.entityID, by: Constants.jumpImpulse / 3, at: event.timestamp)
    }

    func shouldDetach(in entityManager: EntityManager) -> Bool {
        guard let timerComponent = entityManager.component(ofType: TimedComponent.self, of: effectEntity) else {
            return false
        }

        return timerComponent.time >= Constants.powerUpEffectDuration
    }
}
