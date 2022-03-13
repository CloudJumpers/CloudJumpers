//
//  GameScene.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/9/22.
//

import SpriteKit

class GameScene: SKScene {
    var gameEngine: GameEngine!
    var joystick: Joystick!
    var lastUpdateTime: TimeInterval = -1

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white

        addChild(joystick.innerStick)
        addChild(joystick.outerStick)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            joystick.handleTouchBegan(touchLocation: location)
            
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            joystick.handleTouchMoved(touchLocation: location)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.handleTouchEnded()
    }

    override func update(_ currentTime: TimeInterval) {
        guard lastUpdateTime != -1 else {
            lastUpdateTime = currentTime
            return
        }
        
        joystick.update()
        
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        gameEngine.update(deltaTime)
    }
    
    /* All Scene logic (which you could extend to multiple files) */

}
