//
//  PhysicsComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import CoreGraphics

typealias PhysicsBitMask = UInt32

class PhysicsComponent: Component {
    let size: CGSize

    var affectedByGravity = false
    var allowsRotation = false
    var restitution: CGFloat = 0
    var impulse = CGVector.zero

    var categoryBitMask: PhysicsBitMask = PhysicsCategory.max
    var collisionBitMask: PhysicsBitMask = PhysicsCollision.max
    var contactTestBitMask: PhysicsBitMask = PhysicsContactTest.max

    init(rectangleOf size: CGSize) {
        self.size = size
        super.init()
    }
}
