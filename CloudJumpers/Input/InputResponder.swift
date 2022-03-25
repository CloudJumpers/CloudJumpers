//
//  InputResponder.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

protocol InputResponder: AnyObject {
    var associatedEntity: Entity? { get set }

    func inputMove(by displacement: CGVector)
    func inputJump()
    func inputPause()

    func setPowerUp(powerUp: PowerUpButton)
    func activatePowerUp()
}

extension InputResponder {
    func inputMove(by displacement: CGVector) { }
    func inputJump() { }
    func inputPause() { }
    func setPowerUp(powerUp: PowerUpButton) { }
    func activatePowerUp() { }
}
