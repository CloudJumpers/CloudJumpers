//
//  Constants.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 12/3/22.
//

import UIKit

struct Constants {
    static let playerImage = "player"
    static let innerstickImage = "innerStick"
    static let outerstickImage = "outerStick"
    static let outerstickSize = CGSize(width: 100.0, height: 100.0)
    static let innerstickSize = CGSize(width: 50.0, height: 50.0)

    static let playerSize = CGSize(width: 50.0, height: 60.0)

    static let joystickPosition = CGPoint(x: -280.0, y: -420.0)

    static let playerInitialPosition = CGPoint(x: 0, y: 0)

    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let gameSceneSize = CGSize(width: screenWidth,
                                      height: screenHeight)

    static let speedMultiplier = 0.15

    static let opacityOne = 0.3
    static let opacityTwo = 0.6

    static let stickReleaseMovementDuration = 0.2

    static let jumpButtonPosition = CGPoint(x: 280.0, y: -420.0)
    static let jumpButtonImage = "outerStick"
    static let jumpButtonSize = CGSize(width: 100.0, height: 100.0)
    static let jumpImpulse = CGVector(dx: 0.0, dy: 100.0)
    static let jumpYTolerance = 0.1
}
