//
//  PowerSpawnSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

// TODO: Implement this
class PowerSpawnSystem: System {
    var active = false

    unowned var manager: EntityManager?

    var blueprint: Blueprint?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    convenience init(for manager: EntityManager, blueprint: Blueprint) {
        self.init(for: manager)
        self.blueprint = blueprint
    }

    func update(within time: CGFloat) {

        guard RandomSpawnGenerator.isSpawning(successRate: 0.3),
              let blueprint = blueprint
        else {
            return
        }

        let position = RandomSpawnGenerator.getRandomPosition(blueprint: blueprint)
        let powerType = RandomSpawnGenerator.getRandomPowerType() ?? .confuse
        let powerId = EntityManager.newEntityID

        let powerUp = PowerUp(powerType, at: position, with: powerId)
        manager?.add(powerUp)

        // TODO: ADD event to spawn remotely
    }
}
