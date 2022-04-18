//
//  TeleportEffectCreator.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation
import CoreGraphics

class TeleportEffectCreator: PowerUpEffectCreator {
    required init() {}

    func create(at location: CGPoint, activatorId: EntityID) -> Entity {
        PowerUpEffect(at: location, removeAfter: Constants.teleportEffectDuration,
                      activatorId: activatorId, texture: .teleportEffect,
                      powerUpComponent: TeleportComponent(position: location, activatorId: activatorId))
    }

    func doesMatch(type: PowerUpComponent.Kind) -> Bool {
        type == .teleport
    }
}
