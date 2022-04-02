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
        guard let disaster = entityManager.entity(with: entityID),
              let otherEntity = entityManager.entity(with: otherEntityID),
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: otherEntity)
        else { return nil }

        var events: [Event] = [RemoveEntityEvent(disaster)]

        // TO DO: Reconsider this later
        if otherEntity is Player && physicsComponent.body.categoryBitMask == Constants.bitmaskPlayer {
            events.append(RespawnEvent(onEntityWith: otherEntityID,
                                       to: Constants.playerInitialPosition,
                                       isSharing: false,
                                       isExecutedLocally: true))
        }

        return events
    }
}
