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
