//
//  PhysicsCollision.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 10/4/22.
//

import Foundation

enum PhysicsCollision: UInt32 {
    case none = 0
    case player = 0xFFFFFF77
    case platform = 0x00000011
    case disaster = 0x00000047
    case wall = 0x00000001
    case guest = 0x00000060
    case max = 0xFFFFFFFF
}
