//
//  GameScene.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/9/22.
//

import SpriteKit

class GameScene: SKScene {
    unowned var sceneDelegate: GameSceneDelegate?

    private var lastUpdateTime: TimeInterval = -1
    private var cameraNode: SKCameraNode?

    var cameraAnchorNode: SKNode?
    var cameraMinY: CGFloat?

    override func sceneDidLoad() {
        super.sceneDidLoad()
        setUpScene()
        setUpPhysicsWorld()
        setUpCamera()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: cameraNode ?? self)
            sceneDelegate?.scene(self, didBeginTouchAt: location)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: cameraNode ?? self)
            sceneDelegate?.scene(self, didMoveTouchAt: location)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: cameraNode ?? self)
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
        panCameraToAnchorNode()
    }

    /// Adds a node that is always positioned relative to the camera's viewport.
    func addStaticChild(_ node: SKNode) {
        cameraNode?.addChild(node)
    }

    private func panCameraToAnchorNode() {
        guard let cameraAnchorNode = cameraAnchorNode else {
            return
        }

        cameraNode?.position.y = max(cameraMinY ?? 0, cameraAnchorNode.position.y)
    }

    private func setUpScene() {
        backgroundColor = SKColor.white
    }

    private func setUpPhysicsWorld() {
        physicsWorld.contactDelegate = self
    }

    private func setUpCamera() {
        let skCameraNode = SKCameraNode()
        cameraNode = skCameraNode
        camera = skCameraNode
        addChild(skCameraNode)
    }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        sceneDelegate?.scene(self, didBeginContact: contact)
    }

    func didEnd(_ contact: SKPhysicsContact) {
        sceneDelegate?.scene(self, didEndContact: contact)
    }
}
