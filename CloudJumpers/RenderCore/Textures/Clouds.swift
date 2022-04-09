//
//  Clouds.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

enum Clouds: TextureName {
    case cloud1
    case cloud2
}

// MARK: - TextureFrameable
extension Clouds: TextureFrameable {
    var setName: TextureSetName { "Clouds" }
    var frameName: TextureName { rawValue }
}
