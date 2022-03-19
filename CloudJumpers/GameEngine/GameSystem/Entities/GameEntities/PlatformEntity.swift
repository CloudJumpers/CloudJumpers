//
//  PlatformEntity.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/18/22.
//

import SpriteKit

class PlatformEntity: SKPhysicalEntity {
    init(position: CGPoint) {
        super.init(type: .platform)
        self.node = createSKNode()
        self.node?.position = position
        self.physicsBody = createSKPhysicsBody()
        self.linkPhysicsBodyToNode()
    }

    override func createSKNode() -> SKNode? {
        let atlas = Textures.clouds.texture
        let sprite = SKSpriteNode(texture: atlas.textureNamed("cloud-1") )
        sprite.size = Constants.cloudNodeSize
        sprite.zPosition = SpriteZPosition.platform.rawValue
        return sprite

    }

    override func createSKPhysicsBody() -> SKPhysicsBody? {
        let physicsbody = SKPhysicsBody(rectangleOf: Constants.cloudPhysicsSize)
        physicsbody.affectedByGravity = false
        physicsbody.allowsRotation = false
        physicsbody.isDynamic = false
        physicsbody.categoryBitMask = Constants.bitmaskPlatform
        physicsbody.contactTestBitMask = Constants.bitmaskPlayer
        return physicsbody
    }
}
