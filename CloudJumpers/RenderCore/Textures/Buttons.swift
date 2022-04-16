//
//  Buttons.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

enum Buttons: TextureName {
    case home
}

// MARK: - TextureFrameable
extension Buttons: TextureFrameable {
    var setName: TextureSetName { "Buttons" }
    var frameName: TextureName { rawValue }
}
