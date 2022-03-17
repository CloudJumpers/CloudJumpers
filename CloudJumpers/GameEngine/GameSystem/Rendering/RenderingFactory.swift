//
//  SKNodeFactory.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import SpriteKit

class RenderingFactory {
    static func createSKNode(renderingComponent: RenderingComponent) -> SKNode? {
        switch renderingComponent.type {
        case .timer:
            return createSKLabelNode(renderingComponent: renderingComponent)
        default:
            return createSKSpriteNode(renderingComponent: renderingComponent)
        }
    }

    static func createSKSpriteNode(renderingComponent: RenderingComponent) -> SKSpriteNode? {
        let sprite = SKSpriteNode(imageNamed: renderingComponent.name)
        sprite.position = renderingComponent.position
        sprite.size = renderingComponent.size

        switch renderingComponent.type {
        case .physicalSprite(let shape):
            sprite.physicsBody = createPhysicsBody(shape: shape)
            sprite.physicsBody?.allowsRotation = false
            sprite.zPosition = SpriteZPosition.player.rawValue
        case .outerstick:
            sprite.zPosition = SpriteZPosition.outerStick.rawValue
            sprite.alpha = Constants.opacityOne
        case .innerstick:
            sprite.zPosition = SpriteZPosition.innerStick.rawValue
            sprite.alpha = Constants.opacityTwo
        case .button:
            sprite.zPosition = SpriteZPosition.button.rawValue
        default:
            return nil
        }
        return sprite
    }

    static func createSKLabelNode(renderingComponent: RenderingComponent) -> SKNode? {
        let sprite = SKLabelNode()
        sprite.position = renderingComponent.position
        sprite.fontSize = renderingComponent.size.width

        switch renderingComponent.type {
        case let .timer(time):
            sprite.text = "\(time)"
            sprite.fontColor = .black
            sprite.zPosition = SpriteZPosition.timer.rawValue
        default:
            return nil
        }
        return sprite
    }

    static func createPhysicsBody(shape: RenderingComponent.PhysicsShape) -> SKPhysicsBody {
        switch shape {
        case .circle(radius: let radius):
            return SKPhysicsBody(circleOfRadius: radius)
        case .rectangle(size: let size):
            return SKPhysicsBody(rectangleOf: size)
        }
    }
}
