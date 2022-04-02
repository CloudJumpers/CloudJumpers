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
        CGPoint(x: -50, y: -300),
        CGPoint(x: 50, y: -300),
        CGPoint(x: -150, y: -300),
        CGPoint(x: 150, y: -300)
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
    static let powerUpNodeSize = CGSize(width: 60.0, height: 60.0)
    static let initialPowerUpQueuePosition = CGPoint(x: -120.0, y: -420.0)
    static let powerUpQueueXInterval = 80.0

    static let bitmaskPlayer = UInt32(0x1 << 0)
    static let bitmaskCloud = UInt32(0x1 << 1)
    static let bitmaskPlatform = UInt32(0x1 << 2)
    static let bitmaskPowerUp = UInt32(0x1 << 3)
    static let bitmaskDisaster = UInt32(0x1 << 4)
    static let bitmaskWall = UInt32(0x1 << 5)
    static let bitmaskFloor = UInt32(0x1 << 6)
    static let bitmaskGuest = UInt32(0x1 << 7)

    static let testLevelName = "TestLevelOne"
    static let prodLevelName = "LevelOne"

    static let gameAreaSize = CGSize(width: UIScreen.main.bounds.width - 170,
                                     height: UIScreen.main.bounds.height - 240)
    static let gameAreaPosition = CGPoint(x: 0, y: 110)

    static let powerUpEffectSize = CGSize(width: 80.0, height: 80.0)
    static let powerUpEffectDuration = 5.0
    static let powerUpMass = 0.000_000_1

    static let wallWidth = 0.1
    static let wallHeightFromPlatform = 2_000.0
    static let leftWallPosition = CGPoint(x: -350, y: 76.7)
    static let rightWallPosition = CGPoint(x: 350, y: 76.7)

    static let floorSize = CGSize(width: 750.0, height: 300.0)
    static let floorPosition = CGPoint(x: 0, y: -500)

    static let disasterNodeSize = CGSize(width: 30.0, height: 150.0)
    static let disasterPhysicsSize = CGSize(width: 30.0, height: 1.0)

    static let defaultPosition = CGPoint(x: 0.0, y: 0.0)
    static let defaultVelocity = CGVector(dx: 0.0, dy: 0.0)
}
