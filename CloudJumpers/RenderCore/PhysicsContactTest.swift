//
//  PhysicsContactTest.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 10/4/22.
//

import Foundation

struct PhysicsContactTest {
    static let none: PhysicsBitMask = 0
    static let player: PhysicsBitMask = 0xFFFFFF7F
    static let cloud: PhysicsBitMask = 0x00000091
    static let platform: PhysicsBitMask = 0x00000011
    static let powerUp: PhysicsBitMask = 0x00000001
    static let disaster: PhysicsBitMask = 0x00000047
    static let floor: PhysicsBitMask = 0x00000010
    static let guest: PhysicsBitMask = 0x00000062
    static let max: PhysicsBitMask = 0xFFFFFFFF
}
