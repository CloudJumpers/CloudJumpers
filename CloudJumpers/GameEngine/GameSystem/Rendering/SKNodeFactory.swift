//
//  SKNodeFactory.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import Foundation
import SpriteKit

class SKNodeFactory {

    static func createSKSpriteNode(renderingComponent: RenderingComponent) -> SKSpriteNode {
        switch renderingComponent.type {
        case .sprite:
            let sprite = SKSpriteNode(imageNamed: renderingComponent.name)
            sprite.physicsBody = SKPhysicsBody(rectangleOf: renderingComponent.size)
            sprite.physicsBody?.allowsRotation = false
            sprite.position = renderingComponent.position
            sprite.size = renderingComponent.size
            sprite.zPosition = SpriteZPosition.player.rawValue
            return sprite

        case .background:
            return SKSpriteNode(imageNamed: "background")

        case .outerstick:
            let sprite = SKSpriteNode(imageNamed: renderingComponent.name)
            sprite.position = renderingComponent.position
            sprite.size = renderingComponent.size
            sprite.zPosition = SpriteZPosition.outerStick.rawValue
            sprite.alpha = Constants.opacityOne
            return sprite

        case .innerstick:
            let sprite = SKSpriteNode(imageNamed: renderingComponent.name)
            sprite.position = renderingComponent.position
            sprite.size = renderingComponent.size
            sprite.zPosition = SpriteZPosition.innerStick.rawValue
            sprite.alpha = Constants.opacityTwo
            return sprite
        }
    }

}
