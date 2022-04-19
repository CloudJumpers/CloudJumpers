//
//  GodPowerSpawnSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/17/22.
//

import CoreGraphics
import ContentGenerator

class GodPowerSpawnSystem: System {
    var active = false

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        guard RandomSpawnGenerator.isSpawning(successRate: 0.3) else {
            return
        }

        let powerType = PowerUpComponent.Kind.randomly ?? .confuse
        let powerId = EntityManager.newEntityID

        dispatcher?.dispatch(ExternalGodPowerUpSpawnEvent(
            godPowerSpawnPositionX: .zero,
            godPowerSpawnPositionY: .zero,
            godPowerUpType: powerType.rawValue,
            godPowerUpId: powerId))
    }
}
