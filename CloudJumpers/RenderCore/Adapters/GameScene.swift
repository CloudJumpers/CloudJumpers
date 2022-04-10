//
//  GameScene.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/9/22.
//

import SpriteKit

class GameScene: SKScene {
    unowned var renderer: Renderer?
    unowned var sceneDelegate: GameSceneDelegate?

    private var lastUpdateTime: TimeInterval = -1
    private var cameraNode: SKCameraNode?
    private var cameraAnchorNode: SKNode?

    var cameraMinY: CGFloat?

    override func sceneDidLoad() {
        super.sceneDidLoad()
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

    override func didFinishUpdate() {
        sceneDelegate?.scene(self, didUpdateBecome: children.map { $0.position })
    }

    /// `static = true` adds a child that is always positioned relative to the camera's viewport.
    func addChild(_ node: Node, static: Bool = false) {
        if `static` {
            cameraNode?.addChild(node.nodeCore)
        } else {
            super.addChild(node.nodeCore)
        }
    }

    func removeChild(_ node: Node) {
        node.nodeCore.removeFromParent()

        if cameraAnchorNode == node.nodeCore {
            cameraAnchorNode = nil
        }
    }

    func bindCamera(to node: Node) {
        cameraAnchorNode = node.nodeCore
    }

    private func panCameraToAnchorNode() {
        guard let cameraAnchorNode = cameraAnchorNode else {
            return
        }

        cameraNode?.position.y = max(cameraMinY ?? 0, cameraAnchorNode.position.y)
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
        let (nodeA, nodeB) = contactNodes(of: contact)
        sceneDelegate?.scene(self, didBeginContactBetween: nodeA, and: nodeB)
    }

    func didEnd(_ contact: SKPhysicsContact) {
        let (nodeA, nodeB) = contactNodes(of: contact)
        sceneDelegate?.scene(self, didEndContactBetween: nodeA, and: nodeB)
    }

    private func contactNodes(of contact: SKPhysicsContact) -> (nodeA: Node, nodeB: Node) {
        guard let skNodeA = contact.bodyA.node,
              let skNodeB = contact.bodyB.node
        else { fatalError("One SKPhysicsBody has a missing SKNode") }

        guard let nodeA = renderer?.node(of: skNodeA),
              let nodeB = renderer?.node(of: skNodeB)
        else { fatalError("GameScene has a missing reference to Renderer") }

        return (nodeA, nodeB)
    }
}