//
//  PlayerComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/12/22.
//

import Foundation
class PlayerComponent: Component {
    var position: Position
    
    init(position: Position = .start) {
        self.position = position
    }
    
    enum Position {
        case start, air,cloud(entity:Entity),platform(entity:Entity)
    }
}
