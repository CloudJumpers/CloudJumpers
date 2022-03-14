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
    var position: CGPoint
    var name: String
    var size: CGSize

    init (type: SpriteType, position: CGPoint, name: String, size: CGSize) {
        self.type = type
        self.position = position
        self.name = name
        self.size = size
    }

    enum SpriteType {
        case sprite
        case background
        case outerstick
        case innerstick
    }
}

extension RenderingComponent {
    func contains(_ point: CGPoint) -> Bool {
        let startX = position.x - size.width / 2
        let endX = position.x + size.width / 2
        let startY = position.y - size.height / 2
        let endY = position.y + size.height / 2

        let isPointXinside = startX <= point.x && point.x <= endX
        let isPointYinside = startY <= point.y && point.y <= endY
        return isPointXinside && isPointYinside
    }
}
