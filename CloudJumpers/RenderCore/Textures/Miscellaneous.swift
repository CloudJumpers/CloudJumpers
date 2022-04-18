//
//  Miscellaneous.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 14/4/22.
//

enum Miscellaneous: TextureName {
    case confuse
    case freeze
    case slowmo
    case teleport
    case blackout
    case knife
    case confuseEffect
    case freezeEffect
    case slowmoEffect
    case teleportEffect
    case blackoutEffect
    case knifeEffect
    case meteor
    case meteorPrompt
    case wall
    case floor
}

// MARK: - TextureFrameable
extension Miscellaneous: TextureFrameable {
    var setName: TextureSetName { "Miscellaneous" }
    var frameName: TextureName { rawValue }
}
