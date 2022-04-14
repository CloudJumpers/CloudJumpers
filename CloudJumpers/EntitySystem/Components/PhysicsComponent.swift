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

    var mass: CGFloat?
    var velocity: CGVector = .zero
    var isDynamic = true
    var affectedByGravity = false
    var allowsRotation = false
    var restitution: CGFloat = .zero
    var impulse: CGVector = .zero
    var linearDamping: CGFloat = 0.1

    var categoryBitMask: PhysicsBitMask = PhysicsCategory.max
    var collisionBitMask: PhysicsBitMask = PhysicsCollision.max
    var contactTestBitMask: PhysicsBitMask = PhysicsContactTest.max

    init(rectangleOf size: CGSize) {
        self.size = size
        super.init()
    }
}
