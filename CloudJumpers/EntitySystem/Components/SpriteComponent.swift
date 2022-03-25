//
//  SpriteComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class SpriteComponent: Component {
    let id: ID
    unowned var entity: Entity?

    let node: SKNode

    init(texture: SKTexture, size: CGSize, at position: CGPoint) {
        id = UUID()
        node = SKSpriteNode(texture: texture, size: size)
        node.position = position
    }

    init(imageNamed name: String, at position: CGPoint) {
        id = UUID()
        node = SKSpriteNode(imageNamed: name)
        node.position = position
    }

    convenience init(texture: SKTexture, at position: CGPoint) {
        self.init(texture: texture, size: texture.size(), at: position)
    }

    init(node: SKNode) {
        id = UUID()
        self.node = node
    }
}
