//
//  GameScene.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/9/22.
//

import SpriteKit

class GameScene: SKScene {
    weak var updateDelegate: SceneUpdateDelegate?
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
        updateDelegate?.sceneDidFinishUpdate(self)
    }

    /// `static = true` adds a child that is always positioned relative to the camera's viewport.
    func addChild(_ node: NodeCore, static: Bool = false) {
        if `static` {
            cameraNode?.addChild(node)
        } else {
            super.addChild(node)
        }
    }

    func removeChild(_ node: NodeCore) {
        node.removeFromParent()

        if cameraAnchorNode == node {
            cameraAnchorNode = nil
        }
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
        updateDelegate?.scene(self, didBeginContactBetween: nodeA, and: nodeB)
    }

    func didEnd(_ contact: SKPhysicsContact) {
        let (nodeA, nodeB) = contactNodes(of: contact)
        updateDelegate?.scene(self, didEndContactBetween: nodeA, and: nodeB)
    }

    private func contactNodes(of contact: SKPhysicsContact) -> (nodeA: Node, nodeB: Node) {
        guard let skNodeA = contact.bodyA.node,
              let skNodeB = contact.bodyB.node
        else { fatalError("A SKPhysicsBody has a missing SKNode") }

        guard let nodeA = updateDelegate?.node(of: skNodeA),
              let nodeB = updateDelegate?.node(of: skNodeB)
        else { fatalError("A NodeCore was not associated with any Nodes in Renderer") }

        return (nodeA, nodeB)
    }
}

// MARK: - Scene
extension GameScene: Scene {
    var nodes: [Node] {
        guard let updateDelegate = updateDelegate else {
            fatalError("No SceneUpdateDelegate was associated with this GameScene")
        }

        return children.compactMap(updateDelegate.node(of:))
    }

    func contains(_ node: Node) -> Bool {
        children.contains(node.coreNode) || (cameraNode?.contains(node.coreNode) ?? false)
    }

    func addChild(_ node: Node, static: Bool = false) {
        addChild(node.coreNode, static: `static`)
    }

    func removeChild(_ node: Node) {
        removeChild(node.coreNode)
    }

    func isCameraBoundNode(_ node: Node) -> Bool {
        guard let cameraAnchorNode = cameraAnchorNode else {
            return false
        }

        return cameraAnchorNode == node.coreNode
    }

    func bindCamera(to node: Node) {
        cameraAnchorNode = node.coreNode
    }

    func isStaticNode(_ node: Node) -> Bool {
        cameraNode?.children.contains(node.coreNode) ?? false
    }

    func setStaticNode(_ node: Node) {
        guard contains(node) else {
            return
        }

        removeChild(node)
        addChild(node, static: true)
    }

    func setUnstaticNode(_ node: Node) {
        guard contains(node) else {
            return
        }

        removeChild(node)
        addChild(node, static: false)
    }
}
