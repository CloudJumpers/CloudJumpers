//
//  PhysicsCollision.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 10/4/22.
//

import Foundation

struct PhysicsCollision {
    static let none: PhysicsBitMask = 0
    static let player: PhysicsBitMask = PhysicsCategory.max ^ PhysicsCategory.guest ^
                                        PhysicsCategory.shadowGuest ^ PhysicsCategory.powerUp
    static let cloud: PhysicsBitMask = PhysicsCategory.disaster | PhysicsCategory.player
    static let platform: PhysicsBitMask = PhysicsCategory.player | PhysicsContactTest.disaster
    static let powerUp: PhysicsBitMask = PhysicsCategory.none
    static let disaster: PhysicsBitMask = PhysicsCategory.cloud | PhysicsCategory.player |
                                          PhysicsCategory.platform | PhysicsCategory.floor
    static let wall: PhysicsBitMask = PhysicsCategory.player
    static let floor: PhysicsBitMask = PhysicsCategory.disaster | PhysicsCategory.player
    static let guest: PhysicsBitMask = PhysicsCategory.wall | PhysicsCategory.floor
    static let shadowGuest: PhysicsBitMask = PhysicsCategory.wall | PhysicsCategory.floor
    static let max: PhysicsBitMask = 0xFFFFFFFF
}
