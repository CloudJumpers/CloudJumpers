//
//  Textures.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 15/3/22.
//

import SpriteKit

enum Textures: String {
    case buttons = "Buttons"
    case clouds = "Clouds"
    case characters = "Characters"
    case hud = "HUD"
    case charJumpRight = "CharJumpRight"
    case charPreRight = "CharPreRight"
    case charWalkRight = "CharWalkRight"

    var name: String {
        rawValue
    }

    var texture: SKTextureAtlas {
        SKTextureAtlas(named: rawValue)
    }
}
