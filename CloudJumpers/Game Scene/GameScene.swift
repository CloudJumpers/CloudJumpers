//
//  GameScene.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 11/3/22.
//

import SpriteKit

enum NodeZPosition: CGFloat {
    // z-index in increasing order
    case background, player, outerStick, innerStick, button
}


class GameScene: SKScene {
    let speedMultiplier: CGFloat = Constants.speedMultiplier
    var stickActive = false
    
    // TODO: Change player with actual `Player` model
    lazy var player: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: Constants.playerImage)
        sprite.position = Constants.playerInitialPosition
        sprite.zPosition = NodeZPosition.player.rawValue
        return sprite
    }()
    
    lazy var innerStick: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: Constants.innerstickImage)
        sprite.position = Constants.joystickPosition
        sprite.zPosition = NodeZPosition.innerStick.rawValue
        return sprite
    }()
    
    lazy var outerStick: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: Constants.outerstickImage)
        sprite.position = Constants.joystickPosition
        sprite.zPosition = NodeZPosition.outerStick.rawValue
        return sprite
    }()
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        addChild(player)
        addChild(innerStick)
        addChild(outerStick)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if innerStick.frame.contains(location) {
                stickActive = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if stickActive {
                moveInnerStick(to: location)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if stickActive {
            let move: SKAction = SKAction.move(to: outerStick.position, duration: 0.2)
            move.timingMode = .easeOut
            
            innerStick.run(move)
            stickActive = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if stickActive {
            let location = innerStick.position
            movePlayer(withJoystickLocation: location)
        }
    }
    
    private func moveInnerStick(to location: CGPoint) {
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
    
    private func getJoystickAngle(location: CGPoint) -> (CGFloat, CGFloat) {
        let diff = CGVector(dx: location.x - outerStick.position.x,
                            dy: location.y - outerStick.position.y)
        
        let angle = atan2(diff.dy, diff.dx)
        
        let xAngle = sin(angle - .pi / 2)
        let yAngle = cos(angle - .pi / 2)
        
        return (xAngle, yAngle)
    }
    
    // TODO: Check out of bound inside actual `Player` model
    private func movePlayer(withJoystickLocation location: CGPoint) {
        let (xAngle, yAngle) = getJoystickAngle(location: location)
        
        let dist = location.distance(to: outerStick.position)
        let xDist = xAngle * dist
        let yDist = yAngle * dist
        
        self.player.position = CGPoint(x: self.player.position.x - xDist * speedMultiplier,
                                       y: self.player.position.y + yDist * speedMultiplier)
    }
}
