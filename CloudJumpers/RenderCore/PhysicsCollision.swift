//
//  PhysicsCollision.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 10/4/22.
//

import Foundation

struct PhysicsCollision {
    static let none: PhysicsBitMask = 0
    static let player: PhysicsBitMask = 0xFFFFFF77
    static let platform: PhysicsBitMask = 0x00000011
    static let disaster: PhysicsBitMask = 0x00000047
    static let wall: PhysicsBitMask = 0x00000001
    static let guest: PhysicsBitMask = 0x00000060
    static let max: PhysicsBitMask = 0xFFFFFFFF
}
