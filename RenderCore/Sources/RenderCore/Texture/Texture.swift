//
//  Texture.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

import SpriteKit

public struct Texture {
    public static func texture(of textureFrame: TextureFrame) -> SKTexture {
        set(of: textureFrame.setName).textureNamed(textureFrame.name)
    }

    public static func textures(of textureFrames: [TextureFrame]) -> [SKTexture] {
        textureFrames.map(texture(of:))
    }

    public static func textureNames(from setName: TextureSetName) -> [TextureName] {
        set(of: setName).sortedTextureNames
    }

    static func set(of name: TextureSetName) -> SKTextureAtlas {
        SKTextureAtlas(named: name)
    }
}
