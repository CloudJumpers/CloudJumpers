//
//  PlayerEntity.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/15/22.
//

import CoreGraphics
import SpriteKit

class PlayerEntity: SKPhysicalEntity {
    static let atlas = Textures.characters.texture

    init(position: CGPoint) {
        super.init(type: .player)
        self.node = createSKNode()
        self.node?.position = position
        self.physicsBody = createSKPhysicsBody()
        self.linkPhysicsBodyToNode()

    }

    override func createSKNode() -> SKNode? {
        let sprite = SKSpriteNode(texture: PlayerEntity.atlas.textureNamed("chara-1") )
        sprite.size = Constants.playerSize
        sprite.zPosition = SpriteZPosition.player.rawValue
        return sprite

    }

    override func createSKPhysicsBody() -> SKPhysicsBody? {
        let newPhysicsBody = SKPhysicsBody(rectangleOf: Constants.playerSize)
        newPhysicsBody.affectedByGravity = true
        newPhysicsBody.allowsRotation = false
        newPhysicsBody.categoryBitMask = Constants.bitmaskPlayer

        return newPhysicsBody
    }
}
