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

        return MoveEvent(onEntityWith: event.entityID, by: .zero, at: event.timestamp)
    }

    func shouldDetach(in target: EventModifiable) -> Bool {
        guard let effectorDetachSystem = target.system(ofType: EffectorDetachSystem.self) else {
            return false
        }

        return effectorDetachSystem.shouldDetach(watchingEntity: effectEntity)
    }
}
