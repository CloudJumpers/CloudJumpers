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
    static let timerInitial: Double = 0.0

    static let hudSize = CGSize(width: 320, height: 80)
    static let hudPosition = CGPoint(x: 0, y: 410)

    static let scoreLabelPosition = CGPoint(x: -250, y: 410)

    static let cloudNodeSize = CGSize(width: 200.0, height: 100.0)
    static let cloudPhysicsSize = CGSize(width: 200.0, height: 1.0)
    static let platformNodeSize = CGSize(width: 200.0, height: 100.0)
    static let platformPhysicsSize = CGSize(width: 200.0, height: 1.0)
    static let powerUpNodeSize = CGSize(width: 60.0, height: 60.0)
    static let powerUpMaxNumDisplay = 5
    static let powerUpTargetRange = (Constants.powerUpEffectSize.width + Constants.playerSize.width) / 2
    static let initialPowerUpQueuePosition = CGPoint(x: -140.0, y: -420.0)
    static let powerUpQueueXInterval = 80.0
    static let powerUpRemoveTime = 7.0

    static let testLevelName = "TestLevelOne"
    static let prodLevelName = "LevelOne"

    static let gameAreaSize = CGSize(width: UIScreen.main.bounds.width,
                                     height: UIScreen.main.bounds.height + 1_000_000)
    static let gameAreaPosition = CGPoint(x: 0, y: 0)

    static let powerUpEffectSize = CGSize(width: 120.0, height: 120.0)
    static let powerUpEffectDuration = 5.0
    static let powerUpMass = 0.000_000_1

    static let wallWidth = 0.1
    static let wallHeightFromPlatform = 2_000.0
    static let leftWallPosition = CGPoint(x: -350, y: 76.7)
    static let rightWallPosition = CGPoint(x: 350, y: 76.7)

    static let floorSize = CGSize(width: 750.0, height: 300.0)
    static let floorPosition = CGPoint(x: 0, y: -500)

    static let disasterNodeSize = CGSize(width: 30.0, height: 80.0)
    static let disasterPromptSize = CGSize(width: 30.0, height: 30.0)
    static let disasterPromptPeriod = 4.0
    static let disasterPhysicsSize = CGSize(width: 30.0, height: 1.0)
    static let disasterMass = CGFloat(1_000_000)
    static let disasterMinSpeed = Float(100.0)
    static let disasterMaxSpeed = Float(170.0)
    static let disasterMinYPosition = -100.0
    static let disasterGenerationProbability = 1
    static let disasterYPositionOffset = 100.0
    static let disasterMinXDirection = Float(-1.0)
    static let disasterMaxXDirection = Float(1.0)
    static let disasterMinYDirection = Float(-1.0)
    static let disasterMaxYDirection = Float(-0.1)

    static let defaultPosition = CGPoint(x: 0.0, y: 0.0)
    static let defaultVelocity = CGVector(dx: 0.0, dy: 0.0)

    static let minOutOfBoundX = -450.0
    static let maxOutOfBoundX = 450.0

    static let respawnLoopCount = 8
    static let respawnDuration = 0.15

    static let disasterPromptDuration = disasterPromptPeriod / Double(disasterPromptLoopCount * 2)

    static let disasterPromptLoopCount = 8

    static let captionFontName = "AvenirNextCondensed-DemiBold"
    static let captionFontSize = 14.0
    static let captionMaxLength = 10
    static let captionRelativePosition = CGPoint(x: 0.0, y: 35.0)
    static let playerDisplaynameSize = 5

    static let labelFontSize = 30.0

    static let teleportCloudGapY = CGVector(dx: 0.0, dy: 25.0)
    static let teleportEffectDuration = 0.05

    static let cloudMovingTolerance = 0.001

    static let outOfBoundBufferX = 50.0
    static let outOfBoundBufferY = 1_000.0
    static let minOutOfBoundBufferY = -800.0
}
