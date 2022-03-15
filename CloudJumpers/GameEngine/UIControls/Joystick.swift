//
//  Joystick.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 13/3/22.
//

import Foundation
import SpriteKit

class Joystick: Renderable, Touchable {
    var inputManager: InputManager
    private var stickActive = false

    var renderingComponent = RenderingComponent(type: .outerstick,
                                                position: Constants.joystickPosition,
                                                name: Constants.outerstickImage,
                                                size: Constants.outerstickSize)

    var innerStickRenderingComponent = RenderingComponent(type: .innerstick,
                                                          position: Constants.joystickPosition,
                                                          name: Constants.innerstickImage,
                                                          size: Constants.innerstickSize)

    private var innerstickEntity = Entity(type: .innerstick)
    private var outerstickEntity = Entity(type: .outerstick)

    private var associatedEntity: Entity

    init(inputManager: InputManager, associatedEntity: Entity) {
        self.inputManager = inputManager
        self.associatedEntity = associatedEntity
    }

    @discardableResult
    func activate(renderingSystem: RenderingSystem) -> Entity {
        renderingSystem.addComponent(entity: outerstickEntity,
                                     component: renderingComponent)
        renderingSystem.addComponent(entity: innerstickEntity,
                                     component: innerStickRenderingComponent)

        return outerstickEntity
    }

    func handleTouchBegan(touchLocation: CGPoint) {
        guard innerStickRenderingComponent.contains(touchLocation) else {
            return
        }

        stickActive = true
    }

    func handleTouchMoved(touchLocation: CGPoint) {
        if stickActive {
            moveInnerStick(to: touchLocation)
        }
    }

    func handleTouchEnded(touchLocation: CGPoint) {
        if stickActive {
            let initialLocation = innerStickRenderingComponent.position

            innerStickRenderingComponent.position = renderingComponent.position
            notifyLocationChange(entity: innerstickEntity,
                                 by: innerStickRenderingComponent.position - initialLocation)

            stickActive = false
        }
    }

    func update() {
        if stickActive {
            let location = innerStickRenderingComponent.position
            handleTouchInput(location: location)
        }
    }

    private func handleTouchInput(location: CGPoint) {
        let (xAngle, yAngle) = getJoystickAngle(location: location)

        let dist = location.distance(to: renderingComponent.position)
        let xDist = xAngle * dist
        let yDist = yAngle * dist

        let locationChange = CGVector(dx: -xDist * Constants.speedMultiplier,
                                      dy: yDist * Constants.speedMultiplier)
        notifyLocationChange(entity: associatedEntity, by: locationChange)
    }

    private func moveInnerStick(to location: CGPoint) {
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

        notifyLocationChange(entity: innerstickEntity,
                             by: innerStickRenderingComponent.position - initialLocation)
    }

    private func getJoystickAngle(location: CGPoint) -> (CGFloat, CGFloat) {
        let diff = CGVector(dx: location.x - renderingComponent.position.x,
                            dy: location.y - renderingComponent.position.y)

        let angle = atan2(diff.dy, diff.dx)

        let xAngle = sin(angle - .pi / 2)
        let yAngle = cos(angle - .pi / 2)

        return (xAngle, yAngle)
    }

    private func notifyLocationChange(entity: Entity, by distance: CGVector) {
        let newInput = Input(inputType: .move(entity: entity,
                                              by: distance))
        inputManager.parseInput(input: newInput)
    }

}
