//
//  FreezeEffectCreator.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation
import CoreGraphics

class FreezeEffectCreator: PowerUpEffectCreator {
    required init() {}

    func create(at location: CGPoint, activatorId: EntityID) -> Entity {
        PowerUpEffect(at: location, removeAfter: Constants.powerUpEffectDuration,
                      activatorId: activatorId, texture: .freezeEffect,
                      powerUpComponent: FreezeComponent(position: location, activatorId: activatorId))
    }

    func doesMatch(type: PowerUpComponent.Kind) -> Bool {
        type == .freeze
    }
}
