//
//  PowerUpSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

class PowerUpSystem: System {
    var active = true

    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        }

    func activatePowerUp(_ powerUpID: EntityID, at location: CGPoint) {
        guard let powerUpComponent = manager?.component(ofType: PowerUpComponent.self, of: powerUpID) else {
            return
        }

        let effect = PowerUpEffect(
            powerUpComponent.kind,
            at: location,
            intervalToRemove: Constants.powerUpEffectDuration)

        manager?.add(effect)
        if isPlayerWithinRange(location: location) {
            // TODO: Add send effect
        }
    }

    private func isPlayerWithinRange(location: CGPoint) -> Bool {
        guard let playerTag = manager?.components(ofType: PlayerTag.self).first,
              let player = playerTag.entity,
              let playerPositionComponent = manager?.component(ofType: PositionComponent.self, of: player)
        else {
            return false
        }

        let targetPosition = playerPositionComponent.position
        let targetRange = (Constants.powerUpEffectSize.width + Constants.playerSize.width) / 2
        return location.distance(to: targetPosition) <= targetRange

    }
}
