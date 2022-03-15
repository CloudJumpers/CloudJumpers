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
        self.view?.isMultipleTouchEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            gameEngine.touchableManager.handleTouchBeganEvent(location: location)

        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            gameEngine.touchableManager.handleTouchMovedEvent(location: location)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            gameEngine.touchableManager.handleTouchEndedEvent(location: location)
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

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
        else {
            return
        }
        let newEvent = Event(type: .contact(nodeA: nodeA, nodeB: nodeB))
        gameEngine.eventManager.eventsQueue.append(newEvent)

    }

    func didEnd(_ contact: SKPhysicsContact) {
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
