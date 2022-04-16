//
//  PhysicsBody.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 9/4/22.
//

import SpriteKit

typealias PhysicsBodyCore = SKPhysicsBody

class PhysicsBody {
    let coreBody: PhysicsBodyCore

    init(rectangleOf size: CGSize, center: CGPoint = .zero) {
        coreBody = PhysicsBodyCore(rectangleOf: size, center: center)
    }

    init(circleOf radius: CGFloat, center: CGPoint = .zero) {
        coreBody = PhysicsBodyCore(circleOfRadius: radius, center: center)
    }

    var mass: CGFloat {
        get { coreBody.mass }
        set { coreBody.mass = newValue }
    }

    var velocity: CGVector {
        get { coreBody.velocity }
        set { coreBody.velocity = newValue }
    }

    var affectedByGravity: Bool {
        get { coreBody.affectedByGravity }
        set { coreBody.affectedByGravity = newValue }
    }

    var linearDamping: CGFloat {
        get { coreBody.linearDamping }
        set { coreBody.linearDamping = newValue }
    }

    var isDynamic: Bool {
        get { coreBody.isDynamic }
        set { coreBody.isDynamic = newValue }
    }

    var allowsRotation: Bool {
        get { coreBody.allowsRotation }
        set { coreBody.allowsRotation = newValue }
    }

    var restitution: CGFloat {
        get { coreBody.restitution }
        set { coreBody.restitution = newValue }
    }

    var categoryBitMask: UInt32 {
        get { coreBody.categoryBitMask }
        set { coreBody.categoryBitMask = newValue }
    }

    var collisionBitMask: UInt32 {
        get { coreBody.collisionBitMask }
        set { coreBody.collisionBitMask = newValue }
    }

    var contactTestBitMask: UInt32 {
        get { coreBody.contactTestBitMask }
        set { coreBody.contactTestBitMask = newValue }
    }

    func applyImpulse(_ impulse: CGVector) {
        coreBody.applyImpulse(impulse)
    }
}
