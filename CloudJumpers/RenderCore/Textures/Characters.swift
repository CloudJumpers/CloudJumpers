//
//  Characters.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

enum Characters: TextureSetName {
    case Character1
    case Character2
    case Character3
}

// MARK: - TextureSet Specifications
extension Characters {
    enum Frames: TextureName {
        case idle
        case walking
        case jumping
        case prejump
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
        let textureNames = Texture.set(of: rawValue).sortedTextureNames
        let frameNames = textureNames.filter { $0.contains(name.rawValue) }
        return frameNames.map { TextureFrame(from: rawValue, $0) }
    }
}
