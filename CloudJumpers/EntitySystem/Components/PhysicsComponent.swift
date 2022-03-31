//
//  PhysicsComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class PhysicsComponent: Component {
    let body: SKPhysicsBody

    init(rectangleOf size: CGSize, for spriteComponent: SpriteComponent) {
        body = SKPhysicsBody(rectangleOf: size)
        super.init()
        spriteComponent.node.physicsBody = body
    }

    init(circleOf radius: CGFloat, for spriteComponent: SpriteComponent) {
        body = SKPhysicsBody(circleOfRadius: radius)
        super.init()
        spriteComponent.node.physicsBody = body
    }

    init(texture: SKTexture, size: CGSize, for spriteComponent: SpriteComponent) {
        body = SKPhysicsBody(texture: texture, size: size)
        super.init()
        spriteComponent.node.physicsBody = body
    }

    convenience init(texture: SKTexture, for spriteComponent: SpriteComponent) {
        self.init(texture: texture, size: texture.size(), for: spriteComponent)
    }
}
