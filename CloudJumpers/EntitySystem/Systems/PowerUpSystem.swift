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

    func activatePowerUp(_ powerUpID: EntityID, by activatorId: EntityID, at location: CGPoint) {
        guard let manager = manager,
              let powerUp = manager.entity(with: powerUpID) as? PowerUp,
              let playerTag = manager.components(ofType: PlayerTag.self).first,
              let player = playerTag.entity as? Player,
              let playerPositionComponent = manager.component(ofType: PositionComponent.self, of: player)
        else { return }

        let effect = PowerUpEffect(
            powerUp.kind,
            at: location,
            intervalToRemove: Constants.powerUpEffectDuration)

        manager.add(effect)

        let playerLocation = playerPositionComponent.position

        if (powerUp.canAffectEntity(activatorEntityId: activatorId, targetEntityId: player.id) &&
            powerUp.isAffectingLocation(location: playerLocation)),
           let powerUpEvent = powerUp.activate(on: player, watching: effect) {

            manager.add(powerUpEvent)
        }

        manager.remove(powerUp)
    }

}
