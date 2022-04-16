//
//  InputResponder.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

protocol InputResponder: AnyObject {
    func inputMove(by displacement: CGVector)
    func inputJump()
    func inputPause()
    func activatePowerUp(at location: CGPoint)
}

extension InputResponder {
    func inputMove(by displacement: CGVector) { }
    func inputJump() { }
    func inputPause() { }
    func activatePowerUp(at location: CGPoint) { }
}
