//
//  Event.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 25/3/22.
//

import Foundation

protocol Event {
    var timestamp: TimeInterval { get }
    var entityID: EntityID { get }

    func shouldExecute(in entityManager: EntityManager) -> Bool
    func execute(in entityManager: EntityManager) ->(localEvents: [Event]?, remoteEvents: [RemoteEvent]?)?
}

extension Event {
    func shouldExecute(in entityManager: EntityManager) -> Bool { true }
    func execute(in entityManager: EntityManager) ->(localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? { nil }

    func then(do event: Event) -> Event {
        BiEvent(self, event)
    }
}
