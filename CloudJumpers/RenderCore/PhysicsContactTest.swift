//
//  PhysicsContactTest.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 10/4/22.
//

import Foundation

enum PhysicsContactTest: UInt32 {
    case none = 0
    case player = 0xFFFFFF7F
    case cloud = 0x00000091
    case platform = 0x00000011
    case powerUp = 0x00000001
    case disaster = 0x00000047
    case floor = 0x00000010
    case guest = 0x00000062
    case max = 0xFFFFFFFF
}
