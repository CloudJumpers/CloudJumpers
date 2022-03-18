//
//  CloudEntity.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/18/22.
//

import SpriteKit

class CloudEntity: SKPhysicalEntity {
    static let atlas = Textures.clouds.texture

    init(position: CGPoint) {

        super.init(type: .cloud)
        self.node = createSKNode()
        self.node?.position = position
        self.physicsBody = createSKPhysicsBody()
        self.linkPhysicsBodyToNode()
    }

    override func createSKNode() -> SKNode? {
        let sprite = SKSpriteNode(texture: CloudEntity.atlas.textureNamed("cloud-1") )
        sprite.size = CGSize(width: 100.0, height: 100.0)
        sprite.zPosition = SpriteZPosition.player.rawValue
        return sprite

    }

    override func createSKPhysicsBody() -> SKPhysicsBody? {
        let newPhysicsBody = SKPhysicsBody(texture: CloudEntity.atlas.textureNamed("cloud-1"),
                                           size: CGSize(width: 100.0, height: 20.0))
        newPhysicsBody.affectedByGravity = false
        newPhysicsBody.allowsRotation = false
        return newPhysicsBody
    }
}
