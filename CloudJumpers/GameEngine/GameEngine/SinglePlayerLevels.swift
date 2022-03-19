//
//  SinglePlayerLevels.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 19/3/22.
//

import Foundation
import CoreGraphics

struct SinglePlayerLevels {
    static let levelOne = [
        CloudEntity(position: CGPoint(x: 200, y: -200)),
        CloudEntity(position: CGPoint(x: -100, y: -50)),
        CloudEntity(position: CGPoint(x: 200, y: 100)),
        CloudEntity(position: CGPoint(x: -100, y: 250)),
        CloudEntity(position: CGPoint(x: 200, y: 400)),
        CloudEntity(position: CGPoint(x: -100, y: 550)),
        PlatformEntity(position: CGPoint(x: 0, y: 700))
    ]
}
