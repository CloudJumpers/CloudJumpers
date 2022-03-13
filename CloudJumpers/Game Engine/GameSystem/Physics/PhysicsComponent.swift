//
//  PhysicsComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/12/22.
//

import Foundation

class PhysicsComponent: Component {
    var shape: Shape
    var isUpdating = true
    
    init (shape: Shape) {
        self.shape = shape
    }
    
    enum Shape {
        case player
        case cloud
        case platform
    }
}
