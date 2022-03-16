//
//  Joystick.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 13/3/22.
//

import SpriteKit
import CoreGraphics

class Joystick: Renderable, Touchable {
    private var stickActive = false

    var renderingComponent = RenderingComponent(type: .outerstick,
                                                position: Constants.joystickPosition,
                                                name: Constants.outerstickImage,
                                                size: Constants.outerstickSize)

    var innerStickRenderingComponent = RenderingComponent(type: .innerstick,
                                                          position: Constants.joystickPosition,
                                                          name: Constants.innerstickImage,
                                                          size: Constants.innerstickSize)

    private var touchArea = TouchArea(position: Constants.joystickPosition, size: Constants.innerstickSize)

    private var innerstickEntity = Entity(type: .innerstick)
    private var outerstickEntity = Entity(type: .outerstick)

    private var associatedEntity: Entity

    init(associatedEntity: Entity) {
        self.associatedEntity = associatedEntity
    }

    func activate(renderingSystem: RenderingSystem) {
        renderingSystem.addComponent(entity: outerstickEntity,
                                     component: renderingComponent)
        renderingSystem.addComponent(entity: innerstickEntity,
                                     component: innerStickRenderingComponent)
    }

    func handleTouchBegan(touchLocation: CGPoint) -> Input? {
        guard innerStickRenderingComponent.contains(touchLocation) else {
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

        let initialLocation = innerStickRenderingComponent.position

        innerStickRenderingComponent.position = renderingComponent.position
        touchArea.position = renderingComponent.position

        stickActive = false
        return Input(inputType: .move(entity: innerstickEntity,
                                      by: innerStickRenderingComponent.position - initialLocation))
    }

    func update() -> Input? {
        if stickActive {
            let location = innerStickRenderingComponent.position
            return handleTouchInput(location: location)
        }
        return nil
    }

    private func handleTouchInput(location: CGPoint) -> Input {
        let (xAngle, yAngle) = getJoystickAngle(location: location)

        let dist = location.distance(to: renderingComponent.position)
        let xDist = xAngle * dist
        let yDist = yAngle * dist

        let locationChange = CGVector(dx: -xDist * Constants.speedMultiplier,
                                      dy: yDist * Constants.speedMultiplier)
        return Input(inputType: .move(entity: associatedEntity, by: locationChange))
    }

    private func moveInnerStick(to location: CGPoint) -> Input {
        let (xAngle, yAngle) = getJoystickAngle(location: location)
        let length = renderingComponent.size.width / 2

        let xDist = xAngle * length
        let yDist = yAngle * length

        let initialLocation = innerStickRenderingComponent.position

        if renderingComponent.contains(location) {
            innerStickRenderingComponent.position = location
        } else {
            let finalLocation = CGPoint(x: renderingComponent.position.x - xDist,
                                        y: renderingComponent.position.y + yDist)
            innerStickRenderingComponent.position = finalLocation
        }

        touchArea.position = location
        return Input(inputType: .move(entity: innerstickEntity,
                                      by: innerStickRenderingComponent.position - initialLocation))

    }

    private func getJoystickAngle(location: CGPoint) -> (CGFloat, CGFloat) {
        let diff = CGVector(dx: location.x - renderingComponent.position.x,
                            dy: location.y - renderingComponent.position.y)

        let angle = atan2(diff.dy, diff.dx)

        let xAngle = sin(angle - .pi / 2)
        let yAngle = cos(angle - .pi / 2)

        return (xAngle, yAngle)
    }
}
