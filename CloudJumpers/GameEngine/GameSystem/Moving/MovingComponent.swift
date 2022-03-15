//
//  MovingComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/12/22.
//

import CoreGraphics

class MovingComponent: Component {
    var movement: movementType

    init(movement: movementType) {
        self.movement = movement
    }

    enum movementType {
        case move(distance: CGVector), jump(impulse: CGVector)
    }
}
