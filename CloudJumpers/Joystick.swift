//
//  Joystick.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 13/3/22.
//

import Foundation
import SpriteKit

class Joystick {
    weak var gameScene: GameScene!
    var stickActive = false
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    lazy var innerStick: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: Constants.innerstickImage)
        sprite.position = Constants.joystickPosition
        sprite.zPosition = SpriteZPosition.innerStick.rawValue
        sprite.alpha = Constants.opacityTwo
        return sprite
    }()

    lazy var outerStick: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: Constants.outerstickImage)
        sprite.position = Constants.joystickPosition
        sprite.zPosition = SpriteZPosition.outerStick.rawValue
        sprite.alpha = Constants.opacityOne
        return sprite
    }()
    
    func moveInnerStick(to location: CGPoint) {
        let (xAngle, yAngle) = getJoystickAngle(location: location)
        let length = outerStick.frame.size.height / 2

        let xDist = xAngle * length
        let yDist = yAngle * length

        if outerStick.frame.contains(location) {
            innerStick.position = location
        } else {
            innerStick.position = CGPoint(x: outerStick.position.x - xDist,
                                          y: outerStick.position.y + yDist)
        }
    }
    
    func handleTouchBegan(touchLocation: CGPoint) {
        guard innerStick.frame.contains(touchLocation) else {
            return
        }
        
        stickActive = true
    }
    
    func handleTouchMoved(touchLocation: CGPoint) {
        if stickActive {
            moveInnerStick(to: touchLocation)
        }
    }
    
    func handleTouchEnded() {
        if stickActive {
            let move = SKAction.move(to: outerStick.position,
                                     duration: Constants.stickReleaseMovementDuration)
            move.timingMode = .easeOut

            innerStick.run(move)
            stickActive = false
        }
    }
    
    func update() {
        if stickActive {
            let location = innerStick.position
            handleTouchInput(location: location)
        }
    }
    
    private func handleTouchInput(location: CGPoint) {
        let (xAngle, yAngle) = getJoystickAngle(location: location)

        let dist = location.distance(to: outerStick.position)
        let xDist = xAngle * dist
        let yDist = yAngle * dist
    
        
        let newInput = Input(inputType: .move(by: CGVector(dx: -xDist * Constants.speedMultiplier,
                                                           dy: yDist * Constants.speedMultiplier)))
        gameScene.gameEngine.inputManager.parseInput(input: newInput)
    }
    
    private func getJoystickAngle(location: CGPoint) -> (CGFloat, CGFloat) {
        let diff = CGVector(dx: location.x - outerStick.position.x,
                            dy: location.y - outerStick.position.y)

        let angle = atan2(diff.dy, diff.dx)

        let xAngle = sin(angle - .pi / 2)
        let yAngle = cos(angle - .pi / 2)

        return (xAngle, yAngle)
    }
}
