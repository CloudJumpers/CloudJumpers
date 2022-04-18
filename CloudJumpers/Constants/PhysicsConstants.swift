//
//  PhysicsConstants.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 19/4/22.
//

import CoreGraphics

struct PhysicsConstants {
    static let cloudPhysicsSize = CGSize(width: 200.0, height: 1.0)
    static let platformPhysicsSize = CGSize(width: 200.0, height: 1.0)
    static let disasterPhysicsSize = CGSize(width: 30.0, height: 1.0)

    static let speedMultiplier = 0.15
    static let jumpImpulse = CGVector(dx: 0.0, dy: 150.0)
    static let jumpYTolerance = 0.0

    static let powerUpMass = 0.000_000_1
    static let disasterMass = CGFloat(1_000_000)
}
