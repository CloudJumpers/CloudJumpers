//
//  Positions.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 19/4/22.
//

import CoreGraphics

struct Positions {
    static let joystick = CGPoint(x: -280.0, y: -420.0)
    static let player = CGPoint(x: 0, y: -300)
    static let players = [
        CGPoint(x: -50, y: -300),
        CGPoint(x: 50, y: -300),
        CGPoint(x: -150, y: -300),
        CGPoint(x: 150, y: -300)]

    static let jumpButton = CGPoint(x: 280.0, y: -420.0)
    static let timer = CGPoint(x: -100, y: 400)
    static let hud = CGPoint(x: 0, y: 410)
    static let homeButton = CGPoint(x: -280, y: 420)
    static let playerCaption = CGPoint(x: 0.0, y: 35.0)
    static let scoreLabel = CGPoint(x: 250, y: 410)
    static let floor = CGPoint(x: 0, y: -500)
    static let leftWall = CGPoint(x: -350, y: 76.7)
    static let rightWall = CGPoint(x: 350, y: 76.7)
    static let initialPowerUpQueue = CGPoint(x: -140.0, y: -420.0)
}
