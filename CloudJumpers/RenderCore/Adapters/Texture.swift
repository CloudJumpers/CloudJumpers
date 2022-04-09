//
//  Texture.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

import SpriteKit

struct Texture {
    static func texture(of textureFrame: TextureFrame) -> SKTexture {
        set(of: textureFrame.setName).textureNamed(textureFrame.name)
    }

    static func textures(of textureFrames: [TextureFrame]) -> [SKTexture] {
        textureFrames.map(texture(of:))
    }

    static func set(of name: TextureSetName) -> SKTextureAtlas {
        SKTextureAtlas(named: name)
    }
}
