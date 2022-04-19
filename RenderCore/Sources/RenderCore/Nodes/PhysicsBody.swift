//
//  PhysicsBody.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 9/4/22.
//

import SpriteKit

public typealias PhysicsBodyCore = SKPhysicsBody

public class PhysicsBody {
    let coreBody: PhysicsBodyCore

    public init(rectangleOf size: CGSize, center: CGPoint = .zero) {
        coreBody = PhysicsBodyCore(rectangleOf: size, center: center)
    }

    public init(circleOf radius: CGFloat, center: CGPoint = .zero) {
        coreBody = PhysicsBodyCore(circleOfRadius: radius, center: center)
    }

    public var mass: CGFloat {
        get { coreBody.mass }
        set { coreBody.mass = newValue }
    }

    public var velocity: CGVector {
        get { coreBody.velocity }
        set { coreBody.velocity = newValue }
    }

    public var affectedByGravity: Bool {
        get { coreBody.affectedByGravity }
        set { coreBody.affectedByGravity = newValue }
    }

    public var linearDamping: CGFloat {
        get { coreBody.linearDamping }
        set { coreBody.linearDamping = newValue }
    }

    public var isDynamic: Bool {
        get { coreBody.isDynamic }
        set { coreBody.isDynamic = newValue }
    }

    public var allowsRotation: Bool {
        get { coreBody.allowsRotation }
        set { coreBody.allowsRotation = newValue }
    }

    public var restitution: CGFloat {
        get { coreBody.restitution }
        set { coreBody.restitution = newValue }
    }

    public var categoryBitMask: UInt32 {
        get { coreBody.categoryBitMask }
        set { coreBody.categoryBitMask = newValue }
    }

    public var collisionBitMask: UInt32 {
        get { coreBody.collisionBitMask }
        set { coreBody.collisionBitMask = newValue }
    }

    public var contactTestBitMask: UInt32 {
        get { coreBody.contactTestBitMask }
        set { coreBody.contactTestBitMask = newValue }
    }

    public func applyImpulse(_ impulse: CGVector) {
        coreBody.applyImpulse(impulse)
    }
}
