//
//  PositionComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 9/4/22.
//

import CoreGraphics

class PositionComponent: Component {
    var position: CGPoint
    var side: Side

    init(at position: CGPoint) {
        self.position = position
        side = .right
        super.init()
    }
}

// MARK: - PositionComponent.Side
extension PositionComponent {
    enum Side: CGFloat {
        case left = -1.0
        case right = 1.0
    }
}
