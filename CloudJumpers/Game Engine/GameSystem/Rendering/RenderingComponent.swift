//
//  RenderingComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/10/22.
//

import Foundation
import CoreGraphics

class RenderingComponent: Component {
    var type: SpriteType
    var isUpdating = true
    
    init (type: SpriteType) {
        self.type = type
    }
    
    
    enum SpriteType {
        case sprite(position: CGPoint, name: String)
        case background
    }
}
