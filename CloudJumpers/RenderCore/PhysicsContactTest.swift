//
//  PhysicsContactTest.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 10/4/22.
//

import Foundation

struct PhysicsContactTest {
    static let none: PhysicsBitMask = 0
    static let player: PhysicsBitMask = PhysicsCategory.max ^ PhysicsCategory.guest
    static let cloud: PhysicsBitMask = PhysicsCategory.disaster | PhysicsCategory.player |
    PhysicsCategory.guest | PhysicsCategory.wall
    static let platform: PhysicsBitMask = PhysicsCategory.disaster | PhysicsCategory.player | PhysicsCategory.guest
    static let powerUp: PhysicsBitMask = PhysicsCategory.player
    static let disaster: PhysicsBitMask = PhysicsCategory.cloud | PhysicsCategory.player |
    PhysicsCategory.platform | PhysicsCategory.floor
    static let wall: PhysicsBitMask = PhysicsCategory.cloud
    static let floor: PhysicsBitMask = PhysicsCategory.disaster
    static let guest: PhysicsBitMask = PhysicsCategory.wall | PhysicsCategory.floor |
    PhysicsCategory.cloud | PhysicsCategory.platform
    static let shadowGuest: PhysicsBitMask = PhysicsCategory.wall | PhysicsCategory.floor
    static let max: PhysicsBitMask = 0xFFFFFFFF
}
