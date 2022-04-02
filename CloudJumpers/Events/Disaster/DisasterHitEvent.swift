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

    func execute(in entityManager: EntityManager) ->(localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? {
        guard let disaster = entityManager.entity(with: entityID),
              let otherEntity = entityManager.entity(with: otherEntityID),
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: otherEntity)
        else { return nil }

        var localEvents: [Event] = [RemoveEntityEvent(disaster)]
        var remoteEvents: [RemoteEvent] = []

        // TODO: Reconsider this later

        if physicsComponent.body.categoryBitMask == Constants.bitmaskPlayer {
            localEvents.append(RespawnEvent(onEntityWith: otherEntityID, to: Constants.playerInitialPosition))
            remoteEvents.append(ExternalRespawnEvent(
                positionX: Constants.playerInitialPosition.x,
                positionY: Constants.playerInitialPosition.y
            ))
        }

        return (localEvents, remoteEvents)
    }
}
