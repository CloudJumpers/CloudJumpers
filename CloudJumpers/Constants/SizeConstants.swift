//
//  Constants.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 12/3/22.
//

import UIKit

struct SizeConstants {
    static let outerstickSize = CGSize(width: 0.125, height: 0.125)
    static let innerstickSize = CGSize(width: 0.065, height: 0.065)
    static let playerSize = CGSize(width: 0.07, height: 0.07)
    static let cloudNodeSize = CGSize(width: 0.25, height: 0.125)
    static let cloudPhysicsSize = CGSize(width: 0.25, height: 0.005)
    static let platformNodeSize = CGSize(width: 0.25, height: 0.125)
    static let platformPhysicsSize = CGSize(width: 0.25, height: 0.005)
    static let timerSize = CGSize(width: 0.04, height: 0.04)
    static let jumpButtonSize = CGSize(width: 0.125, height: 0.125)

//    static let screenWidth = UIScreen.main.bounds.size.width
//    static let screenHeight = UIScreen.main.bounds.size.height
//    static let gameSceneSize = CGSize(width: screenWidth,
//                                      height: screenHeight)

    static let speedMultiplier = 0.15

    static let stickReleaseMovementDuration = 0.2

    static let jumpImpulse = CGVector(dx: 0.0, dy: 150.0)
    static let jumpYTolerance = 0.0

    static let timerName = ""
    static let timerInitial: Double = 0.0

    static let testLevelName = "TestLevelOne"
    static let prodLevelName = "LevelOne"
}
