//
//  PowerSpawnSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics
import ContentGenerator

class PowerSpawnSystem: System {
    var active = false

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    private var positionsTemplate: PositionsTemplate? {
        guard let size = manager?.components(ofType: AreaComponent.self).first?.size else {
            return nil
        }
        return PositionsTemplate(worldSize: size)
    }

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        guard RandomSpawnGenerator.isSpawning(successRate: 0.3),
              let positionsTemplate = positionsTemplate
        else { return }

        let position = RandomSpawnGenerator.getRandomPosition(positionsTemplate)
        let powerType = PowerUpComponent.Kind.randomly ?? .confuse
        let powerId = EntityManager.newEntityID

        let powerUp = PowerUp(powerType, at: position, with: powerId)

        dispatcher?.dispatch(ExternalPowerUpSpawnEvent(powerSpawnPositionX: position.x,
                                                       powerSpawnPositionY: position.y,
                                                       powerUpType: powerType.rawValue,
                                                       powerUpId: powerId))

        manager?.add(powerUp)
    }
}
