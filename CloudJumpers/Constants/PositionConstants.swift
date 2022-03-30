//
//  PositionConstants.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/30/22.
//

import CoreGraphics

struct PositionConstants {
    static let joystickPosition = CGPoint(x: -0.35, y: -0.53)

    // TO DO: Remove this when done abstracting player setup
    static let playerInitialPosition = CGPoint(x: 0, y: -300)
    static let playerInitialPositions = [
        CGPoint(x: 0.1, y: -0.365),
        CGPoint(x: 0.25, y: -0.365),
        CGPoint(x: -0.1, y: -0.365),
        CGPoint(x: -0.25, y: -0.365)
    ]

    static let jumpButtonPosition = CGPoint(x: 0.35, y: -0.53)
    static let timerPosition = CGPoint(x: 0.3, y: 0.51)

}
