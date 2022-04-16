//
//  PositionComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 9/4/22.
//

import CoreGraphics

class PositionComponent: Component {
    var position: CGPoint

    init(at position: CGPoint) {
        self.position = position
        super.init()
    }
}
