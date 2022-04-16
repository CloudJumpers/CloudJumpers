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
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func activatePowerUp(_ powerUpID: EntityID, activatorId: EntityID, at location: CGPoint) {
        guard let powerUpComponent = manager?.component(ofType: PowerUpComponent.self, of: powerUpID) else {
            return
        }

        let effect = PowerUpEffectFactory.createPowerUpEffect(type: powerUpComponent.kind,
                                                              at: location, activatorId: activatorId)

        manager?.add(effect)
        manager?.remove(withID: powerUpID)
    }
}
