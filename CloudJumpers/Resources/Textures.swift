//
//  Textures.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 15/3/22.
//

import SpriteKit

enum Textures: String, CaseIterable {
    enum Kind: String {
        case idle
        case walking
        case jumping
        case prejump

        var name: String { rawValue }
    }

    // MARK: - Supported Texture Atlases
    case character1 = "Character1"

    // MARK: - Accessors
    static var allIdle: [SKTexture] {
        allCases.map { $0.idle }
    }

    var atlas: SKTextureAtlas {
        SKTextureAtlas(named: self.rawValue)
    }

    var idle: SKTexture {
        atlas.textureNamed(Kind.idle.name)
    }

    var walking: [SKTexture] {
        of(Kind.walking)
    }

    var jumping: [SKTexture] {
        of(Kind.jumping)
    }

    func of(_ kind: Kind) -> [SKTexture] {
        let name = kind.name
        var textures: [SKTexture] = []

        for textureName in atlas.textureNames where textureName.contains(name) {
            textures.append(atlas.textureNamed(textureName))
        }

        return textures
    }
}
