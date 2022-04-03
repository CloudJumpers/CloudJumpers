//
//  PowerUpEffectStartEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 3/4/22.
//

import Foundation
import CoreGraphics

struct PowerUpEffectStartEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private var position: CGPoint
    private var powerUpType: PowerUpComponent.Kind

    init(position: CGPoint, powerUpType: PowerUpComponent.Kind) {
        timestamp = EventManager.timestamp
        entityID = EntityManager.newEntityID
        self.position = position
        self.powerUpType = powerUpType
     }

    init(position: CGPoint, at timestamp: TimeInterval,
         powerUpType: PowerUpComponent.Kind) {
        entityID = EntityManager.newEntityID
        self.position = position
        self.timestamp = timestamp
        self.powerUpType = powerUpType
     }

    func execute(in entityManager: EntityManager) -> (localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? {
        let effect = PowerUpEffect(powerUpType, at: position)
        entityManager.add(effect)

        return ([RemoveEntityEvent(effect.id, after: Constants.powerUpEffectDuration),
                 BlinkEffectEvent(on: effect.id,
                                  duration: Constants.powerUpEffectDuration / 10,
                                  numberOfLoop: 5)], nil)
    }
}
