//
//  DeferredEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 1/4/22.
//

import Foundation

struct DeferredEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID
    let condition: () -> Bool
    let action: () -> Void

    init(_ entity: Entity, until condition: @escaping () -> Bool,
         action: @escaping () -> Void) {
        timestamp = EventManager.timestamp
        entityID = entity.id
        self.condition = condition
        self.action = action
    }

    func shouldExecute(in entityManager: EntityManager) -> Bool {
        condition()
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        action()
        return nil
    }
}
