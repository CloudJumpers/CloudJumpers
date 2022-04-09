//
//  PhysicsBody.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 9/4/22.
//

import SpriteKit

typealias PhysicsBodyCore = SKPhysicsBody

class PhysicsBody {
    let bodyCore: PhysicsBodyCore

    init(rectangleOf size: CGSize, center: CGPoint = .zero) {
        bodyCore = SKPhysicsBody(rectangleOf: size, center: center)
    }

    var affectedByGravity: Bool {
        get { bodyCore.affectedByGravity }
        set { bodyCore.affectedByGravity = newValue }
    }

    var allowsRotation: Bool {
        get { bodyCore.allowsRotation }
        set { bodyCore.allowsRotation = newValue }
    }

    var restitution: CGFloat {
        get { bodyCore.restitution }
        set { bodyCore.restitution = newValue }
    }

    var categoryBitMask: UInt32 {
        get { bodyCore.categoryBitMask }
        set { bodyCore.categoryBitMask = newValue }
    }

    var collisionBitMask: UInt32 {
        get { bodyCore.collisionBitMask }
        set { bodyCore.collisionBitMask = newValue }
    }

    var contactTestBitMask: UInt32 {
        get { bodyCore.contactTestBitMask }
        set { bodyCore.contactTestBitMask = newValue }
    }

    func applyImpulse(_ impulse: CGVector) {
        bodyCore.applyImpulse(impulse)
    }
}
