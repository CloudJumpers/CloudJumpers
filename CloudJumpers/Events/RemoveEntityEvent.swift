//
//  RemoveEntityEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 1/4/22.
//

import Foundation

struct RemoveEntityEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    let timeToRemove: TimeInterval

    init(_ entity: Entity, after timeToRemove: TimeInterval) {
        timestamp = EventManager.timestamp
        entityID = entity.id
        self.timeToRemove = timeToRemove
    }

    init(_ entity: Entity) {
        self.init(entity, after: 0)
    }

    func shouldExecute(in entityManager: EntityManager) -> Bool {
        guard timeToRemove > 0,
              let entity = entityManager.entity(with: entityID),
              let timedComponent = entityManager.component(ofType: TimedComponent.self, of: entity)
        else { return true }

        return timedComponent.time >= timeToRemove
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        entityManager.remove(withID: entityID)

        return nil
    }
}
