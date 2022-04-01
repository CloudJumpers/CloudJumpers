//
//  AnimationComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

class AnimationComponent: Component {
    let texture: Textures
    var kind: Textures.Kind

    init(texture: Textures, kind: Textures.Kind) {
        self.texture = texture
        self.kind = kind
        super.init()
    }
}
