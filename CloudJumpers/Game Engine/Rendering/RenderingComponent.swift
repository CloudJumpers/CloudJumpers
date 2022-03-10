//
//  RenderingComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/10/22.
//

import Foundation

class RenderingComponent: Component {
    var type: RenderType
    
    init (type: RenderType) {
        self.type = type
    }
    enum RenderType {
        case sprite(name: String), background
    }
}
