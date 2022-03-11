//
//  MovingComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/12/22.
//

import Foundation
import CoreGraphics

class MovingComponent: Component {
    var direction: CGVector
    var magnitude: CGFloat
    
    init(direction: CGVector, magnitude: CGFloat) {
        self.direction = direction
        self.magnitude = magnitude
    }
}
