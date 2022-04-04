//
//  RespawnEffectEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/1/22.
//

import SpriteKit

struct RespawnEffectEvent: Event {
    var timestamp: TimeInterval

    var entityID: EntityID
    var originalPosition: CGPoint

    init(onEntityWith id: EntityID, at originalPosition: CGPoint) {
        timestamp = EventManager.timestamp
        self.entityID = id
        self.originalPosition = originalPosition

    }

    init(onEntityWith id: EntityID, at timestamp: TimeInterval, at originalPosition: CGPoint) {
        self.entityID = id
        self.timestamp = timestamp
        self.originalPosition = originalPosition
    }

    func execute(in entityManager: EntityManager) ->(localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? {

        // TO DO: Add in explosion effect at original position

        return ([BlinkEffectEvent(on: entityID,
                                  duration: Constants.respawnDuration,
                                  numberOfLoop: Constants.respawnLoopCount)],
                nil)
    }
}
