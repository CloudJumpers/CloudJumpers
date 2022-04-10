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
    var active = true

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

        let velocity = RandomSpawnGenerator.getRandomVector(blueprint: blueprint)
        let position = RandomSpawnGenerator.getRandomPosition(blueprint: blueprint)
        let powerType = RandomSpawnGenerator.getRandomPowerType() ?? .confuse
        let powerId = EntityManager.newEntityID

        // TODO: ADD event to spawn locally and remote
    }
}
