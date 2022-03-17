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

    private var innerstickEntity = InnerStick()
    private var outerstickEntity = OuterStick()

    private var innerStick: RenderingComponent {
        innerstickEntity.renderingComponent
    }

    private var outerStick: RenderingComponent {
        outerstickEntity.renderingComponent
    }

    private var associatedEntity: Entity

    init(associatedEntity: Entity) {
        self.associatedEntity = associatedEntity
    }

    func activate(renderingSystem: RenderingSystem) {
        innerstickEntity.activate(renderingSystem: renderingSystem)
        outerstickEntity.activate(renderingSystem: renderingSystem)
    }

    func handleTouchBegan(touchLocation: CGPoint) -> Input? {
        guard innerStick.contains(touchLocation) else {
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

        let initialLocation = innerStick.position

        innerStick.position = outerStick.position
        touchArea.position = outerStick.position

        stickActive = false
        return Input(inputType: .move(entity: innerstickEntity,
                                      by: innerStick.position - initialLocation))
    }

    func update() -> Input? {
        if stickActive {
            let location = innerStick.position
            return handleTouchInput(location: location)
        }
        return nil
    }

    private func handleTouchInput(location: CGPoint) -> Input {
        let (xAngle, yAngle) = getJoystickAngle(location: location)

        let dist = location.distance(to: outerStick.position)
        let xDist = xAngle * dist
        let yDist = yAngle * dist

        let locationChange = CGVector(dx: -xDist * Constants.speedMultiplier,
                                      dy: yDist * Constants.speedMultiplier)
        return Input(inputType: .move(entity: associatedEntity, by: locationChange))
    }

    private func moveInnerStick(to location: CGPoint) -> Input {
        let (xAngle, yAngle) = getJoystickAngle(location: location)
        let length = outerStick.size.width / 2

        let xDist = xAngle * length
        let yDist = yAngle * length

        let initialLocation = innerStick.position

        if outerStick.contains(location) {
            innerStick.position = location
        } else {
            let finalLocation = CGPoint(x: outerStick.position.x - xDist,
                                        y: outerStick.position.y + yDist)
            innerStick.position = finalLocation
        }

        touchArea.position = location
        return Input(inputType: .move(entity: innerstickEntity,
                                      by: innerStick.position - initialLocation))

    }

    private func getJoystickAngle(location: CGPoint) -> (CGFloat, CGFloat) {
        let diff = CGVector(dx: location.x - outerStick.position.x,
                            dy: location.y - outerStick.position.y)

        let angle = atan2(diff.dy, diff.dx)

        let xAngle = sin(angle - .pi / 2)
        let yAngle = cos(angle - .pi / 2)

        return (xAngle, yAngle)
    }

    class InnerStick: Entity, Renderable {
        var renderingComponent = RenderingComponent(type: .innerstick,
                                                    position: Constants.joystickPosition,
                                                    name: Images.innerStick.name,
                                                    size: Constants.innerstickSize)
        init() {
            super.init(type: .innerstick)
        }
        func activate(renderingSystem: RenderingSystem) {
            renderingSystem.addComponent(entity: self,
                                         component: renderingComponent)
        }
    }

    class OuterStick: Entity, Renderable {
        var renderingComponent = RenderingComponent(type: .outerstick,
                                                    position: Constants.joystickPosition,
                                                    name: Images.outerStick.name,
                                                    size: Constants.outerstickSize)
        init() {
            super.init(type: .outerstick)
        }

        func activate(renderingSystem: RenderingSystem) {
            renderingSystem.addComponent(entity: self,
                                         component: renderingComponent)
        }
    }

}
