//
//  Constants.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 12/3/22.
//

import Foundation
import CoreGraphics
import UIKit

struct Constants {
    static let playerImage = "player"
    static let innerstickImage = "innerStick"
    static let outerstickImage = "outerStick"
    
    static let joystickPosition = CGPoint(x: 150.0, y: 150.0)
    
    static let playerInitialPosition = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
    
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let gameSceneSize = CGSize(width: screenWidth,
                                      height: screenHeight)
    
    static let speedMultiplier = 0.15
}
