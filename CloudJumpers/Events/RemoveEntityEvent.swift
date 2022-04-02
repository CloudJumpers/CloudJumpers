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

    init(_ entityId: EntityID, after timeToRemove: TimeInterval) {
        timestamp = EventManager.timestamp
        entityID = entityId
        self.timeToRemove = timeToRemove
    }

    init(_ entityId: EntityID) {
        self.init(entityId, after: 0)
    }

    func shouldExecute(in entityManager: EntityManager) -> Bool {
        guard timeToRemove > 0,
              let entity = entityManager.entity(with: entityID),
              let timedComponent = entityManager.component(ofType: TimedComponent.self, of: entity)
        else { return true }

        return timedComponent.time >= timeToRemove
    }

    func execute(in entityManager: EntityManager) ->(localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? {
        entityManager.remove(withID: entityID)

        return nil
    }
}
