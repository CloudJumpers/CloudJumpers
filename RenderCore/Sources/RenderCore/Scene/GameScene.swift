//
//  GameScene.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/9/22.
//

import SpriteKit

public class GameScene: SKScene {
    public weak var updateDelegate: SceneUpdateDelegate?
    public unowned var sceneDelegate: GameSceneDelegate?

    private var lastUpdateTime: TimeInterval = -1
    private var cameraNode: Camera?
    private var cameraAnchorNode: SKNode?

    public var scrollable = false

    public var isBlank = false {
        didSet { isBlank ? blankScreen() : unblankScreen() }
    }

    var touchBeganTouch: UITouch?
    var previousTouchStoppedCameraInertia = false

    // MARK: - Scene Lifecycle
    override public func sceneDidLoad() {
        super.sceneDidLoad()
        backgroundColor = .white
        setUpPhysicsWorld()
        setUpCamera()
    }

    override public func update(_ currentTime: TimeInterval) {
        guard lastUpdateTime != -1 else {
            lastUpdateTime = currentTime
            return
        }

        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        sceneDelegate?.scene(self, updateWithin: deltaTime)
        panCameraToAnchorNode()
    }

    override public func didFinishUpdate() {
        updateDelegate?.sceneDidFinishUpdate(self)
    }

    // MARK: - Touches
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touchLocations = touches.map { $0.location(in: self) }
        sceneDelegate?.scene(self, didBeginTouchesAt: touchLocations)

        guard let touch = touches.first else {
            return
        }

        let location = touch.location(in: cameraNode ?? self)
        prepareCameraToPan(at: location)
        touchBeganTouch = touch
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        let touchLocations = touches.map { $0.location(in: self) }
        sceneDelegate?.scene(self, didMoveTouchesAt: touchLocations)

        guard let touch = touches.first else {
            return
        }

        moveCameraToTouch(at: touch.location(in: cameraNode ?? self))
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        let touchLocations = touches.map { $0.location(in: self) }
        sceneDelegate?.scene(self, didEndTouchesAt: touchLocations)

        guard let touch = touches.first else {
            return
        }

        endCameraPanning(at: touch.location(in: cameraNode ?? self))
        previousTouchStoppedCameraInertia = false

        delegateCompletedTouch(at: touch)
    }

    /// `static = true` adds a child that is always positioned relative to the camera's viewport.
    public func addChild(_ node: NodeCore, static: Bool = false) {
        if `static` {
            cameraNode?.addChild(node)
        } else {
            super.addChild(node)
        }
    }

    public func removeChild(_ node: NodeCore) {
        node.removeFromParent()

        if cameraAnchorNode == node {
            cameraAnchorNode = nil
        }
    }

    // MARK: - Set-up Methods
    private func setUpPhysicsWorld() {
        physicsWorld.contactDelegate = self
    }

    private func setUpCamera() {
        let skCameraNode = Camera(minY: frame.minY, maxY: frame.maxY)
        cameraNode = skCameraNode
        camera = skCameraNode
        addChild(skCameraNode)
    }

    private func delegateCompletedTouch(at touch: UITouch) {
        guard let touchBeganTouch = touchBeganTouch,
              touchBeganTouch == touch,
              !previousTouchStoppedCameraInertia
        else { return }

        let touchLocation = touch.location(in: self)
        sceneDelegate?.scene(self, didCompletedTouchAt: touchLocation)
    }

    // MARK: - Camera
    private func panCameraToAnchorNode() {
        guard let cameraAnchorNode = cameraAnchorNode,
              !scrollable
        else { return }

        cameraNode?.position.y = cameraAnchorNode.position.y
    }

    private func prepareCameraToPan(at location: CGPoint) {
        guard scrollable else {
            return
        }

        if cameraNode?.isInertialPanning ?? false {
            previousTouchStoppedCameraInertia = true
        }

        cameraNode?.stopInertia()
        cameraNode?.lastPosition = location
    }

    private func moveCameraToTouch(at location: CGPoint) {
        guard scrollable,
              let lastPosition = cameraNode?.lastPosition
        else { return }

        cameraNode?.panVertically(by: lastPosition.y - location.y)
        cameraNode?.lastPosition = location
    }

    private func endCameraPanning(at location: CGPoint) {
        guard scrollable,
              let lastPosition = cameraNode?.lastPosition
        else { return }

        cameraNode?.easeWithInertia(by: lastPosition.y - location.y)
        cameraNode?.lastPosition = nil
    }

    // MARK: - Scene Blanking
    private func blankScreen() {
        alpha = 0
        backgroundColor = .black
    }

    private func unblankScreen() {
        alpha = 1
        backgroundColor = .white
    }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
        guard let (nodeA, nodeB) = contactNodes(of: contact) else {
            return
        }

        updateDelegate?.scene(self, didBeginContactBetween: nodeA, and: nodeB)
    }

    public func didEnd(_ contact: SKPhysicsContact) {
        guard let (nodeA, nodeB) = contactNodes(of: contact) else {
            return
        }

        updateDelegate?.scene(self, didEndContactBetween: nodeA, and: nodeB)
    }

    private func contactNodes(of contact: SKPhysicsContact) -> (nodeA: Node, nodeB: Node)? {
        guard let skNodeA = contact.bodyA.node,
              let skNodeB = contact.bodyB.node
        else { fatalError("A SKPhysicsBody has a missing SKNode") }

        guard let nodeA = updateDelegate?.node(of: skNodeA),
              let nodeB = updateDelegate?.node(of: skNodeB)
        else { return nil }

        return (nodeA, nodeB)
    }
}

// MARK: - Scene
extension GameScene: Scene {
    public var nodes: [Node] {
        guard let updateDelegate = updateDelegate else {
            fatalError("No SceneUpdateDelegate was associated with this GameScene")
        }

        return children.compactMap(updateDelegate.node(of:))
    }

    public func contains(_ node: Node) -> Bool {
        children.contains(node.coreNode) || (cameraNode?.contains(node.coreNode) ?? false)
    }

    public func addChild(_ node: Node, static: Bool = false) {
        addChild(node.coreNode, static: `static`)
    }

    public func removeChild(_ node: Node) {
        removeChild(node.coreNode)
    }

    public func isCameraBoundNode(_ node: Node) -> Bool {
        guard let cameraAnchorNode = cameraAnchorNode else {
            return false
        }

        return cameraAnchorNode == node.coreNode
    }

    public func bindCamera(to node: Node) {
        cameraAnchorNode = node.coreNode
    }

    public func isStaticNode(_ node: Node) -> Bool {
        cameraNode?.children.contains(node.coreNode) ?? false
    }

    public func setStaticNode(_ node: Node) {
        guard contains(node) else {
            return
        }

        removeChild(node)
        addChild(node, static: true)
    }

    public func setUnstaticNode(_ node: Node) {
        guard contains(node) else {
            return
        }

        removeChild(node)
        addChild(node, static: false)
    }
}
