//
//  PhysicsComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import CoreGraphics

typealias PhysicsBitMask = UInt32

class PhysicsComponent: Component {
    let shape: Shape
    var size: CGSize?
    var radius: CGFloat?

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
        shape = .rectangle
        self.size = size
        super.init()
    }

    init(circleOf radius: CGFloat) {
        shape = .circle
        self.radius = radius
        super.init()
    }
}

// MARK: - PhysicsComponent.Shape
extension PhysicsComponent {
    enum Shape: Int {
        case rectangle
        case circle
    }
}
