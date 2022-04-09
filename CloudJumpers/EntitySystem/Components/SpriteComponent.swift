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

    init(texture: TextureFrame, size: CGSize, zPosition: SpriteZPosition) {
        self.texture = texture
        self.size = size
        self.zPosition = zPosition
        super.init()
    }
}
