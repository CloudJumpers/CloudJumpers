//
//  CollisionComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import Foundation

class CollisionComponent: Component {
    var shape: Shape
    
    init (shape: Shape) {
        self.shape = shape
    }
    enum Shape {
        case player
        case cloud
        case platform
    }
    
    
    
}
