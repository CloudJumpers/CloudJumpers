//
//  PowerUpManager.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 25/3/22.
//

import Foundation

class PowerUpManager {
    private var powerUp: PowerUpButton?

    func setPowerUp(powerUp: PowerUpButton) {
        self.powerUp?.set(false)
        self.powerUp = powerUp
        self.powerUp?.set(true)
    }

    func activatePowerUp() {
        powerUp?.activatePowerUp()
    }
}
