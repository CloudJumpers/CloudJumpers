//
//  SpriteComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class SpriteComponent: Component {
    let id: ComponentID
    unowned var entity: Entity?

    let node: SKNode

    init(texture: SKTexture, size: CGSize, at position: CGPoint, forEntityWith entityID: EntityID) {
        id = EntityManager.newComponentID
        node = SKSpriteNode(texture: texture, size: size)
        node.position = position
        node.entityID = entityID
    }

    init(imageNamed name: String, at position: CGPoint, forEntityWith entityID: EntityID) {
        id = EntityManager.newComponentID
        node = SKSpriteNode(imageNamed: name)
        node.position = position
        node.entityID = entityID
    }

    convenience init(texture: SKTexture, at position: CGPoint, forEntityWith entityID: EntityID) {
        self.init(texture: texture, size: texture.size(), at: position, forEntityWith: entityID)
    }

    init(node: SKNode, forEntityWith entityID: EntityID) {
        id = EntityManager.newComponentID
        self.node = node
        node.entityID = entityID
    }
}
