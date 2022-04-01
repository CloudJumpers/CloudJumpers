//
//  DisasterHitEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 28/3/22.
//
import Foundation

struct DisasterHitEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let otherEntityID: EntityID

    init(from entityID: EntityID, on otherEntityID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
        self.otherEntityID = otherEntityID
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard let disaster = entityManager.entity(with: entityID)
        else { return nil }

        return [RemoveEntityEvent(disaster, after: Constants.disasterHitDuration)]

        // handle something on the thing the disaster land on
    }
}
