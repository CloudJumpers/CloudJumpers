//
//  GameScene.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/9/22.
//

import SpriteKit

class GameScene: SKScene {
    unowned var sceneDelegate: GameSceneDelegate?
    var lastUpdateTime: TimeInterval = -1

    override func didMove(to view: SKView) {
        setUpScene()
        setUpPhysicsWorld()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            sceneDelegate?.scene(self, didBeginTouchAt: location)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            sceneDelegate?.scene(self, didMoveTouchAt: location)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            sceneDelegate?.scene(self, didEndTouchAt: location)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        guard lastUpdateTime != -1 else {
            lastUpdateTime = currentTime
            return
        }

        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        sceneDelegate?.scene(self, updateWithin: deltaTime)
    }

    private func setUpScene() {
        backgroundColor = SKColor.white
        self.view?.isMultipleTouchEnabled = true
    }

    private func setUpPhysicsWorld() {
        physicsWorld.contactDelegate = self
    }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
        else { return }

        sceneDelegate?.scene(self, didBeginContactBetween: nodeA, and: nodeB)
    }

    func didEnd(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
        else { return }

        sceneDelegate?.scene(self, didEndContactBetween: nodeA, and: nodeB)
    }
}
