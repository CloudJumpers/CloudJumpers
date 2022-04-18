//
//  Dimensions.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 19/4/22.
//

import CoreGraphics

struct Dimensions {
    static let gameArea = CGPoint.zero
    static let outerstick = CGSize(width: 100.0, height: 100.0)
    static let innerstick = CGSize(width: 50.0, height: 50.0)
    static let player = CGSize(width: 60.0, height: 60.0)
    static let jumpButton = CGSize(width: 100.0, height: 100.0)
    static let homeButton = CGSize(width: 60, height: 60)
    static let cloud = CGSize(width: 200.0, height: 100.0)
    static let platform = CGSize(width: 200.0, height: 100.0)
    static let powerUp = CGSize(width: 60.0, height: 60.0)
    static let powerUpEffect = CGSize(width: 120.0, height: 120.0)
    static let floor = CGSize(width: 750.0, height: 300.0)
    static let disaster = CGSize(width: 30.0, height: 80.0)
    static let disasterPrompt = CGSize(width: 30.0, height: 30.0)
    static let hud = CGSize(width: 320, height: 80)
    static let captionFontSize = 14.0
    static let labelFontSize = 25.0
    static let wallWidth = 0.1
    static let wallHeightFromPlatform = 2_000.0
}
