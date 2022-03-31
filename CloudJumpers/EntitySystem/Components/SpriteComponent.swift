//
//  SpriteComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class SpriteComponent: Component {
    let node: SKNode

    init(texture: SKTexture, size: CGSize, at position: CGPoint, forEntityWith entityID: EntityID) {
        node = SKSpriteNode(texture: texture, size: size)
        super.init()
        node.position = position
        node.entityID = entityID
    }

    init(imageNamed name: String, at position: CGPoint, forEntityWith entityID: EntityID) {
        node = SKSpriteNode(imageNamed: name)
        super.init()
        node.position = position
        node.entityID = entityID
    }

    convenience init(texture: SKTexture, at position: CGPoint, forEntityWith entityID: EntityID) {
        self.init(texture: texture, size: texture.size(), at: position, forEntityWith: entityID)
    }

    init(node: SKNode, forEntityWith entityID: EntityID) {
        self.node = node
        super.init()
        node.entityID = entityID
    }
}
