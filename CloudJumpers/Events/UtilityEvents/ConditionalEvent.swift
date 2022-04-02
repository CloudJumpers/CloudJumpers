//
//  ConditionalEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 2/4/22.
//

import Foundation

struct ConditionalEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID
    let condition: () -> Bool
    let action: () -> [Event]?

    init(_ entity: Entity, until condition: @escaping () -> Bool,
         action: @escaping () -> [Event]?) {

        timestamp = EventManager.timestamp
        entityID = entity.id
        self.condition = condition
        self.action = action
     }

    func shouldExecute(in entityManager: EntityManager) -> Bool {
        condition()
    }

    func execute(in entityManager: EntityManager) -> (localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? {
        let localEvents = action()
        return (localEvents, nil)
    }
}
