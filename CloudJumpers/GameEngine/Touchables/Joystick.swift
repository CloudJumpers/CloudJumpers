//
//  Joystick.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 13/3/22.
//

import SpriteKit
import CoreGraphics

class Joystick: Touchable {
    private var stickActive = false
    private var touchArea = TouchArea(position: Constants.joystickPosition, size: Constants.innerstickSize)

    var innerstickEntity = InnerStick()
    var outerstickEntity = OuterStick()

    private var associatedEntity: Entity

    init(associatedEntity: Entity) {
        self.associatedEntity = associatedEntity
    }

    func handleTouchBegan(touchLocation: CGPoint) -> Input? {
        guard let node = self.innerstickEntity.node as? SKSpriteNode,
              touchLocation.isInside(position: node.position, size: node.size)
        else {
            return nil
        }
        stickActive = true
        return nil
    }

    func handleTouchMoved(touchLocation: CGPoint) -> Input? {
        if stickActive {
            return moveInnerStick(to: touchLocation)
        }
        return nil
    }

    func handleTouchEnded(touchLocation: CGPoint) -> Input? {
        guard touchArea.contains(touchLocation),
              stickActive
        else {
            return nil
        }

        guard let innerStick = self.innerstickEntity.node as? SKSpriteNode,
              let outerStick = self.outerstickEntity.node as? SKSpriteNode
        else {
            return nil
        }

        let initialPosition = innerStick.position
        let newPosition = outerStick.position
        touchArea.position = outerStick.position

        stickActive = false
        return Input(inputType: .move(entity: innerstickEntity,
                                      by: newPosition - initialPosition))
    }

    func update() -> Input? {
        if stickActive {
            guard let innerStick = self.innerstickEntity.node as? SKSpriteNode else {
                return nil
            }
            let location = innerStick.position
            return handleTouchInput(location: location)
        }
        return nil
    }

    private func handleTouchInput(location: CGPoint) -> Input? {
        guard let outerStick = self.innerstickEntity.node as? SKSpriteNode else {
            return nil
        }
        let (xAngle, yAngle) = getJoystickAngle(location: location)

        let dist = location.distance(to: outerStick.position)
        let xDist = xAngle * dist
        let yDist = yAngle * dist

        let locationChange = CGVector(dx: -xDist * Constants.speedMultiplier,
                                      dy: yDist * Constants.speedMultiplier)
        return Input(inputType: .move(entity: associatedEntity, by: locationChange))
    }

    private func moveInnerStick(to location: CGPoint) -> Input? {
        guard let innerStick = self.innerstickEntity.node as? SKSpriteNode,
              let outerStick = self.outerstickEntity.node as? SKSpriteNode
        else {
            return nil
        }
        let (xAngle, yAngle) = getJoystickAngle(location: location)
        let length = outerStick.size.width / 2

        let xDist = xAngle * length
        let yDist = yAngle * length

        let initialPosition = innerStick.position
        let finalPosition: CGPoint

        if location.isInside(position: outerStick.position, size: outerStick.size) {
            finalPosition = location
        } else {
            finalPosition = CGPoint(x: outerStick.position.x - xDist,
                                    y: outerStick.position.y + yDist)
        }

        touchArea.position = location
        return Input(inputType: .move(entity: innerstickEntity,
                                      by: finalPosition - initialPosition))

    }

    private func getJoystickAngle(location: CGPoint) -> (CGFloat, CGFloat) {
        guard let outerStick = self.outerstickEntity.node as? SKSpriteNode else {
            return (0, 0)
        }
        let diff = CGVector(dx: location.x - outerStick.position.x,
                            dy: location.y - outerStick.position.y)

        let angle = atan2(diff.dy, diff.dx)

        let xAngle = sin(angle - .pi / 2)
        let yAngle = cos(angle - .pi / 2)

        return (xAngle, yAngle)
    }

    class InnerStick: SKEntity {

        init() {
            super.init(type: .innerstick)
            self.node = createSKNode()
        }
        override func createSKNode() -> SKNode? {
            let sprite = SKSpriteNode(imageNamed: Images.innerStick.name)
            sprite.position = Constants.joystickPosition
            sprite.size = Constants.innerstickSize
            sprite.zPosition = SpriteZPosition.innerStick.rawValue
            sprite.alpha = Constants.opacityTwo
            return sprite
        }
    }

    class OuterStick: SKEntity {
        init() {
            super.init(type: .outerstick)
            self.node = createSKNode()

        }

        override func createSKNode() -> SKNode? {
            let sprite = SKSpriteNode(imageNamed: Images.outerStick.name)
            sprite.position = Constants.joystickPosition
            sprite.size = Constants.outerstickSize

            sprite.zPosition = SpriteZPosition.outerStick.rawValue
            sprite.alpha = Constants.opacityOne
            return sprite
        }

    }

}
