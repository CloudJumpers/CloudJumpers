//
//  Buttons.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

import RenderCore

enum Buttons: TextureName {
    case home
    case innerStick
    case outerStick
}

// MARK: - TextureFrameable
extension Buttons: TextureFrameable {
    var setName: TextureSetName { "Buttons" }
    var frameName: TextureName { rawValue }
}
