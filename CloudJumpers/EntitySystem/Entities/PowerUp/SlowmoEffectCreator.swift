//
//  SlowmoEffectCreator.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation
import CoreGraphics

class SlowmoEffectCreator: PowerUpEffectCreator {
    required init() {}

    func create(at location: CGPoint, activatorId: EntityID) -> Entity {
        PowerUpEffect(at: location, removeAfter: Constants.powerUpEffectDuration,
                      activatorId: activatorId, texture: .slowmoEffect,
                      powerUpComponent: SlowmoComponent(position: location, activatorId: activatorId))
    }

    func doesMatch(type: PowerUpComponent.Kind) -> Bool {
        type == .slowmo
    }
}
