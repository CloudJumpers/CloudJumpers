//
//  Input.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import Foundation
import CoreGraphics

struct Input {
    // This will need to be using Vector to be exact, but this is the idea
    let inputType: InputType
    
    init (inputType: InputType) {
        self.inputType = inputType
    }
    
    enum InputType {
//        case move(direction: MoveDirection), powerup, jump
        case move(entity: Entity, by: CGVector), powerUp, jump, touchBegan(at: CGPoint),
             touchMoved(at: CGPoint),
             touchEnded(at: CGPoint)
    }
    
    enum MoveDirection {
        case left,right,up,down
    }
}
