//
//  Input.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import CoreGraphics

struct Input {
    // This will need to be using Vector to be exact, but this is the idea
    let inputType: InputType

    init (inputType: InputType) {
        self.inputType = inputType
    }

    enum InputType {
        case move(entity: Entity, by: CGVector)
        case jump(entity: Entity)
        case powerUp
    }

    enum MoveDirection {
        case left, right, up, down
    }
}
