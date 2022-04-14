//
//  PhysicsCategory.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 9/4/22.
//

import Foundation

struct PhysicsCategory {
    static let none: PhysicsBitMask = 0
    static let player: PhysicsBitMask = 0x00000001
    static let cloud: PhysicsBitMask = 0x00000002
    static let platform: PhysicsBitMask = 0x00000004
    static let powerUp: PhysicsBitMask = 0x00000008
    static let disaster: PhysicsBitMask = 0x00000010
    static let wall: PhysicsBitMask = 0x00000020
    static let floor: PhysicsBitMask = 0x00000040
    static let guest: PhysicsBitMask = 0x00000080
    static let max: PhysicsBitMask = 0xFFFFFFFF
}
