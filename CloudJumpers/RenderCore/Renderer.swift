//
//  Renderer.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

import SpriteKit

typealias NodesMap = [NodeCore: Node]
typealias EntityNodeMap = [EntityID: Node]
typealias EntityPositionMap = [EntityID: CGPoint]
typealias EntityVelocityMap = [EntityID: CGVector]

class Renderer {
    private unowned var target: Simulatable?
    private unowned var scene: Scene?

    private var renderedNodes: NodesMap
    private var entityNode: EntityNodeMap

    init(from target: Simulatable, to scene: Scene?) {
        renderedNodes = NodesMap()
        entityNode = EntityNodeMap()
        self.target = target
        self.scene = scene
        scene?.updateDelegate = self
    }

    func render() {
        var nodesToPrune = Set(renderedNodes.values)

        for entity in target?.entitiesToRender() ?? [] {
            validate(entity: entity, into: &nodesToPrune)
            synchronize(entity: entity)
        }

        prune(nodes: nodesToPrune)
    }

    func node(of coreNode: NodeCore) -> Node? {
        renderedNodes[coreNode]
    }

    // MARK: - Pre-rendering
    private func validate(entity: Entity, into nodesToPrune: inout Set<Node>) {
        guard let node = entityNode[entity.id] else {
            return
        }

        if nodesToPrune.contains(node) {
            nodesToPrune.remove(node)
        }
    }

    // MARK: - Rendering
    private func synchronize(entity: Entity) {
        if entityNode.contains(key: entity.id) {
            update(entity: entity)
        } else {
            create(entity: entity)
        }
    }

    private func update(entity: Entity) {
        updatePosition(entity: entity)
        updatePhysics(entity: entity)
    }

    // MARK: Update based on component
    private func updatePosition(entity: Entity) {
        guard let node = entityNode[entity.id],
              let positionComponent = target?.component(ofType: PositionComponent.self, of: entity)
        else { return }

        node.position = positionComponent.position
    }

    private func updatePhysics(entity: Entity) {
        guard let node = entityNode[entity.id],
              let physicsComponent = target?.component(ofType: PhysicsComponent.self, of: entity)
        else { return }

        if !physicsComponent.impulse.isZero {
            node.physicsBody?.applyImpulse(physicsComponent.impulse)
        }
    }

    private func updateAnimation(entity: Entity) {
        guard let node = entityNode[entity.id],
              let animationComponent = target?.component(ofType: AnimationComponent.self, of: entity),
              let animation = animationComponent.activeAnimation
        else { return }

        node.animate(with: animation.frames, interval: 0.1)
    }

    private func create(entity: Entity) {
        guard let spriteComponent = target?.component(ofType: SpriteComponent.self, of: entity),
              let positionComponent = target?.component(ofType: PositionComponent.self, of: entity)
        else { return }

        let node = Node(texture: spriteComponent.texture, size: spriteComponent.size)
        node.position = positionComponent.position
        node.name = entity.id

        if let physicsBody = createPhysicsBody(for: entity) {
            node.physicsBody = physicsBody
        }

        let `static` = target?.hasComponent(ofType: CameraStaticTag.self, in: entity)
        scene?.addChild(node, static: `static` ?? false)
        bindCamera(to: node, with: entity)

        cache(entity: entity, node: node)
    }

    private func createPhysicsBody(for entity: Entity) -> PhysicsBody? {
        guard let physicsComponent = target?.component(ofType: PhysicsComponent.self, of: entity) else {
            return nil
        }

        let body = createPhysicsBody(with: physicsComponent)
        if let body = body {
            configurePhysicsBody(body, with: physicsComponent)
        }

        return body
    }

    private func createPhysicsBody(with physicsComponent: PhysicsComponent) -> PhysicsBody? {
        switch physicsComponent.shape {
        case .circle:
            guard let radius = physicsComponent.radius else {
                fatalError("Circle PhysicsComponent does not have a radius")
            }

            return PhysicsBody(circleOf: radius)

        case .rectangle:
            guard let size = physicsComponent.size else {
                fatalError("Rectangle PhysicsComponent does not have a size")
            }

            return PhysicsBody(rectangleOf: size)
        }
    }

    private func configurePhysicsBody(_ body: PhysicsBody, with physicsComponent: PhysicsComponent) {
        if let mass = physicsComponent.mass {
            body.mass = mass
        }

        body.velocity = physicsComponent.velocity
        body.isDynamic = physicsComponent.isDynamic
        body.affectedByGravity = physicsComponent.affectedByGravity
        body.allowsRotation = physicsComponent.allowsRotation
        body.restitution = physicsComponent.restitution
        body.linearDamping = physicsComponent.linearDamping
        body.categoryBitMask = physicsComponent.categoryBitMask
        body.collisionBitMask = physicsComponent.collisionBitMask
        body.contactTestBitMask = physicsComponent.contactTestBitMask
    }

    private func bindCamera(to node: Node, with entity: Entity) {
        guard target?.hasComponent(ofType: CameraAnchorTag.self, in: entity) ?? false else {
            return
        }

        scene?.bindCamera(to: node)
    }

    // MARK: - Post-rendering
    private func prune(nodes: Set<Node>) {
        for node in nodes {
            uncache(node: node)
            remove(node: node)
        }
    }

    private func cache(entity: Entity, node: Node) {
        entityNode[entity.id] = node
        renderedNodes[node.nodeCore] = node
    }

    private func uncache(node: Node) {
        guard let entityID = node.name else {
            fatalError("remove(node:) called on uncached Entity\n\(String(describing: node))")
        }

        entityNode[entityID] = nil
        renderedNodes[node.nodeCore] = nil
    }

    private func remove(node: Node) {
        scene?.removeChild(node)
    }
}

// MARK: - SceneUpdateDelegate
extension Renderer: SceneUpdateDelegate {
    func scene(_ scene: Scene, didBeginContactBetween nodeA: Node, and nodeB: Node) {
        guard let entityIDA = nodeA.name,
              let entityIDB = nodeB.name
        else { fatalError("A Node was not associated with an EntityID") }

        target?.handleContact(between: entityIDA, and: entityIDB)
    }

    func scene(_ scene: Scene, didEndContactBetween nodeA: Node, and nodeB: Node) {
        // TODO: Handle contact end here
    }

    func sceneDidFinishUpdate(_ scene: Scene) {
        let nodes = scene.nodes

        let entityPositionMap = entityPositionMap(from: nodes)
        target?.syncPositions(with: entityPositionMap)

        let entityVelocityMap = entityVelocityMap(from: nodes)
        target?.syncVelocities(with: entityVelocityMap)
    }

    private func entityPositionMap(from nodes: [Node]) -> EntityPositionMap {
        var entityPositionMap = EntityPositionMap()

        for node in nodes {
            guard let entityID = node.name else {
                fatalError("Node \(String(describing: node)) does not have an EntityID")
            }

            entityPositionMap[entityID] = node.position
        }

        return entityPositionMap
    }

    private func entityVelocityMap(from nodes: [Node]) -> EntityVelocityMap {
        var entityVelocityMap = EntityVelocityMap()

        for node in nodes {
            guard let entityID = node.name else {
                fatalError("Node \(String(describing: node)) does not have an EntityID")
            }

            guard let physicsBody = node.physicsBody else {
                continue
            }

            entityVelocityMap[entityID] = physicsBody.velocity
        }

        return entityVelocityMap
    }
}
