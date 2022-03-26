//
//  PowerUpManager.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 25/3/22.
//

import Foundation
import CoreGraphics

class PowerUpManager: InputResponder {
    var associatedEntity: Entity?
    var powerUp: PowerUpButton?
    var powerUpsAvailable: [PowerUpButton] = []

    init(associatedEntity: Entity?) {
        self.associatedEntity = associatedEntity
    }

    func initializePowerUp(powerUps: [PowerUpButton]) {
        self.powerUpsAvailable = powerUps
    }

    // TODO: refactor this!
    func getPowerUp(powerUp: PowerUpType) {
        switch powerUp {
        case .freeze:
            for powerUp in powerUpsAvailable where powerUp is FreezeButton {
                powerUp.increaseQuantity()
                break
            }
        case .confuse:
            for powerUp in powerUpsAvailable where powerUp is ConfuseButton {
                powerUp.increaseQuantity()
                break
            }
        }

    }

    func activatePowerUp(touchLocation: CGPoint) {
        guard let powerUp = powerUp else {
            return
        }

        powerUp.activatePowerUp(location: touchLocation)
        powerUp.decreaseQuantity()

        if powerUp.quantity == 0 {
            powerUp.set(false)
            self.powerUp = nil
        }
    }

    func setPowerUp(powerUp: PowerUpButton) {
        guard powerUp.quantity > 0 else {
            return
        }

        self.powerUp?.set(false)
        self.powerUp = powerUp
        self.powerUp?.set(true)
    }
}
