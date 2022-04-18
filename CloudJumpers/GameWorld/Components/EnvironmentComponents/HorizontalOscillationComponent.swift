//
//  HorizontalOscillationComponent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 16/4/22.
//

import Foundation
import CoreGraphics

class HorizontalOscillationComponent: Component {
    var initialPosition: CGPoint
    var horizontalVelocity: CGFloat

    init(at initialPosition: CGPoint, horizontalVelocity: CGFloat) {
        self.initialPosition = initialPosition
        self.horizontalVelocity = horizontalVelocity
        super.init()
    }
}
