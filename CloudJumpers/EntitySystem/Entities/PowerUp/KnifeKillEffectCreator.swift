//
//  KnifeKillEffectCreator.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 18/4/22.
//

import Foundation
import CoreGraphics

class KnifeKillEffectCreator: PowerUpEffectCreator {
    required init() {}

    func create(at location: CGPoint, activatorId: EntityID) -> Entity {
        PowerUpEffect(at: location, removeAfter: Constants.knifeKillEffectDuration,
                      activatorId: activatorId, texture: .knifeEffect,
                      powerUpComponent: KnifeKillComponent(position: location, activatorId: activatorId))
    }

    func doesMatch(type: PowerUpComponent.Kind) -> Bool {
        type == .knife
    }
}
