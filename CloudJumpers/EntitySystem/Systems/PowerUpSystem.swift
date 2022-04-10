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

    func update(within time: CGFloat) { }

    func activatePowerUp(_ powerUpID: EntityID, at location: CGPoint) {
        guard let manager = manager,
              let entity = manager.entity(with: powerUpID),
              let powerUp = entity as? PowerUp,
              let playerTag = manager.components(ofType: PlayerTag.self).first,
              let player = playerTag.entity as? Player
        else { return }

        let effect = PowerUpEffect(
            powerUp.kind,
            at: location,
            intervalToRemove: Constants.powerUpEffectDuration)

        manager.add(effect)

        if isPlayerWithinRange(player: player, location: location) {
            let effectors = powerUp.activate(on: player, watching: effect)
            for effector in effectors {
                manager.add(effector)
            }
        }

        manager.remove(powerUp)
    }

    private func isPlayerWithinRange(player: Player, location: CGPoint) -> Bool {
        guard let playerPositionComponent = manager?.component(ofType: PositionComponent.self, of: player)
        else {
            return false
        }

        let targetPosition = playerPositionComponent.position
        let targetRange = (Constants.powerUpEffectSize.width + Constants.playerSize.width) / 2
        return location.distance(to: targetPosition) <= targetRange

    }
}
