//
//  SKNodeFactory.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import Foundation
import SpriteKit

class SKNodeFactory {
    
    static func createSKSpriteNode(type: RenderingComponent.SpriteType) -> SKSpriteNode {
        switch type {
        case .sprite(let position, let name):
            let sprite = SKSpriteNode(imageNamed: name)
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody?.allowsRotation = false
            sprite.position = position
            sprite.zPosition = SpriteZPosition.player.rawValue
            return sprite
            
        case .background:
            return SKSpriteNode(imageNamed: "background")
        }
    }
    

}
