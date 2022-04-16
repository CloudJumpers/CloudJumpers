//
//  SpriteComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class SpriteComponent: Component {
    let texture: TextureFrame
    let size: CGSize
    let zPosition: SpriteZPosition

    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var alpha: CGFloat = 1.0
    var zRotation: CGFloat = .zero

    init(texture: TextureFrame, size: CGSize, zPosition: SpriteZPosition) {
        self.texture = texture
        self.size = size
        self.zPosition = zPosition
        super.init()
    }
}
