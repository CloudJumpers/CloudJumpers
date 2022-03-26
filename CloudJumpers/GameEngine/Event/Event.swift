//
//  Event.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import SpriteKit

// Some asynchronous event that require a general handler
class Event {
    let type: EventType
    init (type: EventType) {
        self.type = type
    }

    enum EventType {
        case inputMove(entity: Entity, by: CGVector)
        case inputJump(entity: Entity)
        case getPowerUp(powerUp: PowerUpType, powerUpNode: SKNode)
        case activatePowerUp(type: PowerUpType, location: CGPoint)
        case gameEnd
    }
}
