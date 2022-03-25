//
//  PhysicsComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class PhysicsComponent: Component {
    let id: ID
    unowned var entity: Entity?

    let body: SKPhysicsBody

    init(rectangleOf size: CGSize, for spriteComponent: SpriteComponent) {
        id = UUID()
        body = SKPhysicsBody(rectangleOf: size)
        spriteComponent.node.physicsBody = body
    }

    init(texture: SKTexture, size: CGSize, for spriteComponent: SpriteComponent) {
        id = UUID()
        body = SKPhysicsBody(texture: texture, size: size)
        spriteComponent.node.physicsBody = body
    }

    convenience init(texture: SKTexture, for spriteComponent: SpriteComponent) {
        self.init(texture: texture, size: texture.size(), for: spriteComponent)
    }
}
