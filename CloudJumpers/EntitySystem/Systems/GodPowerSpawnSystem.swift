//
//  GodPowerSpawnSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/17/22.
//

import Foundation
import CoreGraphics

// TODO: Implement this
class GodPowerSpawnSystem: System {
    var active = false

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        guard RandomSpawnGenerator.isSpawning(successRate: 0.3)
        else {
            return
        }

        let powerType = RandomSpawnGenerator.getRandomPowerType() ?? .confuse
        let powerId = EntityManager.newEntityID

        let powerUp = PowerUp(powerType, at: .zero, with: powerId)

        dispatcher?.dispatch(ExternalPowerUpSpawnEvent(powerSpawnPositionX: .zero,
                                                       powerSpawnPositionY: .zero,
                                                       powerUpType: powerType.rawValue,
                                                       powerUpId: powerId))
        manager?.add(powerUp)
        dispatcher?.dispatch(ExternalObtainEntityEvent(obtainedEntityID: powerId))
    }
}
