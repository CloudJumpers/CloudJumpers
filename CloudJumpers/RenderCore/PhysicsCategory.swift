//
//  PhysicsCategory.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 9/4/22.
//

import Foundation

enum PhysicsCategory: UInt32 {
    case none = 0
    case player = 0x00000001
    case cloud = 0x00000002
    case platform = 0x00000004
    case powerUp = 0x00000008
    case disaster = 0x00000010
    case wall = 0x00000020
    case floor = 0x00000040
    case guest = 0x00000080
    case max = 0xFFFFFFFF
}
