//
//  MiscConstants.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/30/22.
//

import CoreGraphics

struct MiscConstants {
    static let opacityOne = 0.3
    static let opacityTwo = 0.6

    static let speedMultiplier = 0.15

    static let stickReleaseMovementDuration = 0.2

    static let jumpImpulse = CGVector(dx: 0.0, dy: 0.19)

    static let tolerance = CGVector(dx: 0.19, dy: 0.19)
    static let jumpYTolerance = 0.0

    static let timerName = ""
    static let timerInitial: Double = 0.0

    static let testLevelName = "TestLevelOne"
    static let prodLevelName = "LevelOne"

    static let bitmaskPlayer = UInt32(0x1 << 0)
    static let bitmaskCloud = UInt32(0x1 << 1)
    static let bitmaskPlatform = UInt32(0x1 << 2)
}
