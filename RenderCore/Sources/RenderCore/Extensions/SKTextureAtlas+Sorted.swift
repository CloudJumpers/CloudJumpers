//
//  SKTextureAtlas+Sorted.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

import SpriteKit

extension SKTextureAtlas {
    var sortedTextureNames: [String] {
        textureNames.sorted()
    }

    var textures: [SKTexture] {
        sortedTextureNames.map(textureNamed(_:))
    }
}
