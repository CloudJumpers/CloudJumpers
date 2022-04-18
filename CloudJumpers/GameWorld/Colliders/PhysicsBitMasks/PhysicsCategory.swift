//
//  PhysicsCategory.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 9/4/22.
//

import Foundation

struct PhysicsCategory {
    static let none: PhysicsBitMask = 0
    static let player: PhysicsBitMask = 0x1 << 0
    static let cloud: PhysicsBitMask = 0x1 << 1
    static let platform: PhysicsBitMask = 0x1 << 2
    static let powerUp: PhysicsBitMask = 0x1 << 3
    static let disaster: PhysicsBitMask = 0x1 << 4
    static let wall: PhysicsBitMask = 0x1 << 5
    static let floor: PhysicsBitMask = 0x1 << 6
    static let guest: PhysicsBitMask = 0x1 << 7
    static let shadowGuest: PhysicsBitMask = 0x1 << 8
    static let max: PhysicsBitMask = 0xFFFFFFFF
}
