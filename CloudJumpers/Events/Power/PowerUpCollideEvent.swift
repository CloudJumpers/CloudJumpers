//
//  PowerUpCollideEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 3/4/22.
//

import Foundation

struct PowerUpCollideEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let powerUpEntityID: EntityID

    init(on entityID: EntityID, powerUp otherEntityID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
        self.powerUpEntityID = otherEntityID
    }

    func execute(in entityManager: EntityManager) ->(localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? {
        guard let entity = entityManager.entity(with: entityID),
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity),
              let otherEntity = entityManager.entity(with: powerUpEntityID),
              let ownerComponent = entityManager.component(ofType: OwnerComponent.self, of: otherEntity),
              ownerComponent.ownerEntityId == nil
        else { return nil }

        var remoteEvents: [RemoteEvent] = []

        if physicsComponent.body.categoryBitMask == Constants.bitmaskPlayer {
            let externalObtainEntityEvent = ExternalObtainEntityEvent(obtainedEntityID: powerUpEntityID)
            remoteEvents.append(externalObtainEntityEvent)
        }

        return (nil, remoteEvents)
    }
}
