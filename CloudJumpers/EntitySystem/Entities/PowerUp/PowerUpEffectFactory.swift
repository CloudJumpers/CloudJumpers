//
//  PowerUpEffectFactory.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 15/4/22.
//

import Foundation
import CoreGraphics

// TODO: try to think of a way to do this better
class PowerUpEffectFactory {
    static func createPowerUpEffect(type: PowerUpComponent.Kind,
                                    at location: CGPoint, activatorId: EntityID) -> PowerUpEffect {
        switch type {
        case .freeze:
            return PowerUpEffect(at: location, removeAfter: Constants.powerUpEffectDuration, activatorId: activatorId,
                                 texture: .freezeEffect,
                                 powerUpComponent: FreezeComponent(position: location, activatorId: activatorId))
        case .confuse:
            return PowerUpEffect(at: location, removeAfter: Constants.powerUpEffectDuration, activatorId: activatorId,
                                 texture: .confuseEffect,
                                 powerUpComponent: ConfuseComponent(position: location, activatorId: activatorId))
        case .slowmo:
            return PowerUpEffect(at: location, removeAfter: Constants.powerUpEffectDuration, activatorId: activatorId,
                                 texture: .slowmoEffect,
                                 powerUpComponent: SlowmoComponent(position: location, activatorId: activatorId))
        case .teleport:
            return PowerUpEffect(at: location, removeAfter: Constants.teleportEffectDuration, activatorId: activatorId,
                                 texture: .teleportEffect,
                                 powerUpComponent: TeleportComponent(position: location, activatorId: activatorId))
        }
    }
}
