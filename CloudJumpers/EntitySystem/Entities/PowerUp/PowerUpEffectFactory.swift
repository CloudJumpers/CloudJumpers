//
//  PowerUpEffectFactory.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 15/4/22.
//

import Foundation
import CoreGraphics

class PowerUpEffectFactory {
    private static let availablePowerUpEffects: [PowerUpEffectCreator.Type] = [
        FreezeEffectCreator.self,
        ConfuseEffectCreator.self,
        SlowmoEffectCreator.self,
        TeleportEffectCreator.self,
        BlackoutEffectCreator.self
    ]

    static func createPowerUpEffect(type: PowerUpComponent.Kind,
                                    at location: CGPoint,
                                    activatorId: EntityID) -> Entity {

        for availablePowerUpEffect in availablePowerUpEffects {
            let powerUpEffectCreator = availablePowerUpEffect.init()
            if powerUpEffectCreator.doesMatch(type: type) {
                return powerUpEffectCreator.create(at: location, activatorId: activatorId)
            }
        }

        fatalError("Unable to find a matching power-up effect for type =\(type.rawValue)")
    }
}
