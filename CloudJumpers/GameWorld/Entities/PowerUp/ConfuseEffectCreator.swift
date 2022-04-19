//
//  ConfuseEffectCreator.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation
import CoreGraphics

class ConfuseEffectCreator: PowerUpEffectCreator {
    required init() {}

    func create(at location: CGPoint, activatorId: EntityID) -> Entity {
        PowerUpEffect(
            at: location,
            removeAfter: Constants.PowerUps.powerUpEffectDuration,
            activatorId: activatorId,
            texture: .confuseEffect,
            powerUpComponent: ConfuseComponent(position: location, activatorId: activatorId))
    }

    func doesMatch(type: PowerUpComponent.Kind) -> Bool {
        type == .confuse
    }
}
