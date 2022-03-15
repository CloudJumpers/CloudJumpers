//
//  GameScene.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/9/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameEngine: GameEngine!
    var lastUpdateTime: TimeInterval = -1

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        self.physicsWorld.contactDelegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let input = Input(inputType: .touchBegan(at: location))
            let newEvent = Event(type: .input(info: input))
            gameEngine.eventManager.eventsQueue.append(newEvent)

        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let input = Input(inputType: .touchMoved(at: location))
            let newEvent = Event(type: .input(info: input))
            gameEngine.eventManager.eventsQueue.append(newEvent)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let input = Input(inputType: .touchEnded(at: location))
            let newEvent = Event(type: .input(info: input))
            gameEngine.eventManager.eventsQueue.append(newEvent)        }
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
        else {
            return
        }
        let newEvent = Event(type: .contact(nodeA: nodeA, nodeB: nodeB))
        gameEngine.eventManager.eventsQueue.append(newEvent)
        
    }
    
    func didEnd(_ contact: SKPhysicsContact){
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
        else {
            return
        }
        let newEvent = Event(type: .endContact(nodeA: nodeA, nodeB: nodeB))
        gameEngine.eventManager.eventsQueue.append(newEvent)
    }

    /* All Scene logic (which you could extend to multiple files) */

}
