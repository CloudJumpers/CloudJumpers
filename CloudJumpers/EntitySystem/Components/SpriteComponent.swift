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
    private(set) var cameraBind: CameraBind

    let node: SKNode

    init(texture: SKTexture, size: CGSize, at position: CGPoint, forEntityWith entityID: EntityID,
         cameraBind: CameraBind = .normalBind) {
        id = EntityManager.newComponentID
        node = SKSpriteNode(texture: texture, size: size)
        node.position = position
        node.entityID = entityID
        self.cameraBind = cameraBind
    }

    init(imageNamed name: String, at position: CGPoint, forEntityWith entityID: EntityID,
         cameraBind: CameraBind = .normalBind) {
        id = EntityManager.newComponentID
        node = SKSpriteNode(imageNamed: name)
        node.position = position
        node.entityID = entityID
        self.cameraBind = cameraBind
    }

    convenience init(texture: SKTexture, at position: CGPoint, forEntityWith entityID: EntityID,
                     cameraBind: CameraBind = .normalBind) {
        self.init(texture: texture, size: texture.size(), at: position, forEntityWith: entityID, cameraBind: cameraBind)
    }

    init(node: SKNode, forEntityWith entityID: EntityID, cameraBind: CameraBind = .normalBind) {
        id = EntityManager.newComponentID
        self.node = node
        node.entityID = entityID
        self.cameraBind = cameraBind
    }
}
