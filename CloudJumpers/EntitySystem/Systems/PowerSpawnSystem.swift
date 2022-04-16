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
    unowned var dispatcher: EventDispatcher?

    var positionGenerationInfo: RandomPositionGenerationInfo?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    convenience init(for manager: EntityManager, positionGenerationInfo: RandomPositionGenerationInfo,
                     dispatcherVia dispatcher: EventDispatcher? = nil) {
        self.init(for: manager, dispatchesVia: dispatcher)
        self.positionGenerationInfo = positionGenerationInfo
    }

    func update(within time: CGFloat) {
        guard RandomSpawnGenerator.isSpawning(successRate: 0.3),
              let positionGenerationInfo = positionGenerationInfo
        else {
            return
        }

        let position = RandomSpawnGenerator.getRandomPosition(positionGenerationInfo)
        let powerType = RandomSpawnGenerator.getRandomPowerType() ?? .confuse
        let powerId = EntityManager.newEntityID

        let powerUp = PowerUp(powerType, at: position, with: powerId)
        manager?.add(powerUp)

        // TODO: ADD event to spawn remotely
    }
}
