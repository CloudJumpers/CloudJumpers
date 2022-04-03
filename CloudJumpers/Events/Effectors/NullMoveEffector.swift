//
//  NullMoveEffector.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 3/4/22.
//

struct NullMoveEffector: Effector {
    let entityID: EntityID

    init(on entity: Entity) {
        entityID = entity.id
    }

    func apply(to event: Event) -> Event {
        guard let event = event as? MoveEvent else {
            return event
        }

        return MoveEvent(onEntityWith: event.entityID, at: event.timestamp, by: .zero)
    }

    func shouldDetach(in entityManager: EntityManager) -> Bool {
        // TODO: - Add timer logic here
        false
    }
}
