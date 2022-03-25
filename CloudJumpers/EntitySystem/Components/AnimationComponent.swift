//
//  AnimationComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import Foundation

class AnimationComponent: Component {
    let id: ID
    unowned var entity: Entity?

    let texture: Textures
    var kind: Textures.Kind

    init(texture: Textures, kind: Textures.Kind) {
        id = UUID()
        self.texture = texture
        self.kind = kind
    }
}
