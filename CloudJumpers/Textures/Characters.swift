//
//  Characters.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

import RenderCore

enum Characters: TextureSetName {
    case Character1
    case ShadowCharacter1
}

// MARK: - Character Animations
typealias CharacterFrames = Characters.Frames

extension Characters {
    enum Frames: TextureName {
        case idle
        case walking
        case jumping
        case prejump

        var key: TextureName { rawValue }
    }
}

// MARK: - TextureFrame Generators
extension Characters {
    var idle: TextureFrame {
        TextureFrame(from: rawValue, Frames.idle.rawValue)
    }

    var walking: [TextureFrame] {
        frames(with: .walking)
    }

    var jumping: [TextureFrame] {
        frames(with: .jumping)
    }

    var prejumping: [TextureFrame] {
        frames(with: .prejump)
    }

    private func frames(with name: Frames) -> [TextureFrame] {
        let textureNames = Texture.textureNames(from: rawValue)
        let frameNames = textureNames.filter { $0.contains(name.rawValue) }
        return frameNames.map { TextureFrame(from: rawValue, $0) }
    }
}
