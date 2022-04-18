//
//  Constants.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 12/3/22.
//

import UIKit

struct Constants {
    static let opacityOne = 0.3
    static let opacityTwo = 0.6

    static let timerInitial = Double.zero

    static let respawnLoopCount = 8
    static let respawnDuration = 0.15

    static let captionMaxLength = 10

    static let cloudMovingTolerance = 0.001

    static let outOfBoundBufferX = 50.0
    static let outOfBoundBufferY = 1_000.0
    static let minOutOfBoundBufferY = -800.0
}

// MARK: - Disasters
extension Constants {
    struct Disasters {
        static let disasterPromptPeriod = 4.0
        static let disasterIdSuffix = "Disaster"
        static let disasterMinSpeed = Float(100.0)
        static let disasterMaxSpeed = Float(170.0)
        static let disasterMinYPosition = -100.0
        static let disasterGenerationProbability = 1
        static let disasterYPositionOffset = 100.0
        static let disasterMinXDirection = Float(-1.0)
        static let disasterMaxXDirection = Float(1.0)
        static let disasterMinYDirection = Float(-1.0)
        static let disasterMaxYDirection = Float(-0.1)
        static let disasterPromptDuration = disasterPromptPeriod / Double(disasterPromptLoopCount * 2)
        static let disasterPromptLoopCount = 8
    }
}

// MARK: - Power-ups
extension Constants {
    struct PowerUps {
        static let powerUpMaxNumDisplay = 5
        static let powerUpTargetRange = (Dimensions.powerUpEffect.width + Dimensions.player.width) / 2
        static let knifeKillEffectDuration = 2.0
        static let teleportCloudGapY = CGVector(dx: 0.0, dy: 25.0)
        static let teleportEffectDuration = 0.05
        static let powerUpQueueXInterval = 80.0
        static let powerUpRemoveTime = 7.0
        static let powerUpEffectDuration = 5.0
    }
}
