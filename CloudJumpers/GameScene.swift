//
//  GameScene.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/9/22.
//

import SpriteKit

class GameScene: SKScene {
    var gameEngine: GameEngine!
    var lastUpdateTime: TimeInterval = -1

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            gameEngine.inputManager.processTouchBegan(at: location)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            gameEngine.inputManager.processTouchMoved(at: location)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            gameEngine.inputManager.processTouchEnded(at: location)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        guard lastUpdateTime != -1 else {
            lastUpdateTime = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        gameEngine.update(deltaTime)
    }
    
    /* All Scene logic (which you could extend to multiple files) */

}
