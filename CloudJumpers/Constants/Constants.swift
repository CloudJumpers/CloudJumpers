//
//  Constants.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 12/3/22.
//

import UIKit

struct Constants {
    static let outerstickSize = CGSize(width: 100.0, height: 100.0)
    static let innerstickSize = CGSize(width: 50.0, height: 50.0)

    static let playerSize = CGSize(width: 60.0, height: 60.0)

    static let joystickPosition = CGPoint(x: -280.0, y: -420.0)

    static let playerInitialPosition = CGPoint(x: 0, y: -300)

    static let playerInitialPositions = [
        CGPoint(x: -50, y: -200),
        CGPoint(x: 50, y: -200),
        CGPoint(x: -150, y: -200),
        CGPoint(x: 150, y: -200)
    ]

    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let gameSceneSize = CGSize(width: screenWidth,
                                      height: screenHeight)

    static let speedMultiplier = 0.15

    static let opacityOne = 0.3
    static let opacityTwo = 0.6

    static let stickReleaseMovementDuration = 0.2

    static let jumpButtonPosition = CGPoint(x: 280.0, y: -420.0)
    static let jumpButtonSize = CGSize(width: 100.0, height: 100.0)
    static let jumpImpulse = CGVector(dx: 0.0, dy: 150.0)
    static let jumpYTolerance = 0.0

    static let timerPosition = CGPoint(x: 250, y: 410)
    static let timerName = ""
    static let timerSize = CGSize(width: 36, height: 36)
    static let timerInitial: Double = 0.0

    // Temporary Constant
    static let cloudNodeSize = CGSize(width: 200.0, height: 100.0)
    static let cloudPhysicsSize = CGSize(width: 200.0, height: 1.0)
    static let platformNodeSize = CGSize(width: 200.0, height: 100.0)
    static let platformPhysicsSize = CGSize(width: 200.0, height: 1.0)

    static let bitmaskPlayer = UInt32(0x1 << 0)
    static let bitmaskCloud = UInt32(0x1 << 1)
    static let bitmaskPlatform = UInt32(0x1 << 2)

    static let testLevelName = "TestLevelOne"
    static let prodLevelName = "LevelOne"
}
