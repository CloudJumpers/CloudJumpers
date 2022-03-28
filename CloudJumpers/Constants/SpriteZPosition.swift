//
//  SpriteZPosition.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 13/3/22.
//

import CoreGraphics

enum SpriteZPosition: CGFloat {
    // z-index in increasing order
    case wall, background, platform, player, powerUp, disaster, outerStick, innerStick, button, timer
}
