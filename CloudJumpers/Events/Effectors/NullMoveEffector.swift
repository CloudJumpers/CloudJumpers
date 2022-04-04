//
//  NullMoveEffector.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 3/4/22.
//

struct NullMoveEffector: Effector {
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

        return MoveEvent(onEntityWith: event.entityID, at: event.timestamp, by: .zero)
    }

    func shouldDetach(in entityManager: EntityManager) -> Bool {
        guard let timerComponent = entityManager.component(ofType: TimedComponent.self, of: effectEntity) else {
            return false
        }

        return timerComponent.time >= Constants.powerUpEffectDuration
    }
}
