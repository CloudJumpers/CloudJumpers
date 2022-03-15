//
//  TouchArea.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/15/22.
//

import CoreGraphics

class TouchArea {
    var position: CGPoint
    var size: CGSize

    init(position: CGPoint, size: CGSize) {
        self.position = position
        self.size = size
    }

    func contains(_ point: CGPoint) -> Bool {
        point.isInside(position: position, size: size)
    }
}
