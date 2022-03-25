//
//  PhysicsComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class PhysicsComponent: Component {
    let id: ComponentID
    unowned var entity: Entity?

    let body: SKPhysicsBody

    init(rectangleOf size: CGSize, for spriteComponent: SpriteComponent) {
        id = UUID().uuidString
        body = SKPhysicsBody(rectangleOf: size)
        spriteComponent.node.physicsBody = body
    }

    init(circleOf radius: CGFloat, for spriteComponent: SpriteComponent) {
        id = UUID().uuidString
        body = SKPhysicsBody(circleOfRadius: radius)
        spriteComponent.node.physicsBody = body
    }

    init(texture: SKTexture, size: CGSize, for spriteComponent: SpriteComponent) {
        id = UUID().uuidString
        body = SKPhysicsBody(texture: texture, size: size)
        spriteComponent.node.physicsBody = body
    }

    convenience init(texture: SKTexture, for spriteComponent: SpriteComponent) {
        self.init(texture: texture, size: texture.size(), for: spriteComponent)
    }
}
