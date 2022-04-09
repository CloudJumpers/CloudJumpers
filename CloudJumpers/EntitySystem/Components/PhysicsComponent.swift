//
//  PhysicsComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import CoreGraphics

class PhysicsComponent: Component {
    let size: CGSize

    var affectedByGravity = false
    var allowsRotation = false
    var restitution: CGFloat = 0
    var impulse = 0

    // TODO: PhysicsCollision, PhysicsContactTest
    var categoryBitMask: PhysicsCategory = .max
    var collisionBitMask: PhysicsCategory = .max
    var contactTestBitMask: PhysicsCategory = .max

    init(rectangleOf size: CGSize) {
        self.size = size
        super.init()
    }
}
