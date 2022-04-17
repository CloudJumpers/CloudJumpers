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
    private let pipeline: RenderPipeline

    init(from target: Simulatable, to scene: Scene?) {
        renderedNodes = NodesMap()
        entityNode = EntityNodeMap()
        pipeline = RenderPipeline()
        self.target = target
        self.scene = scene

        scene?.updateDelegate = self
        setUpPipeline()
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
            createAndCache(entity: entity)
        }
    }

    private func update(entity: Entity) {
        guard let node = entityNode[entity.id] else {
            fatalError("Node \(String(describing: node)) was updated before created/cached")
        }

        pipeline.render(entity, with: node)
    }

    private func createAndCache(entity: Entity) {
        guard let node = pipeline.createNode(for: entity) else {
            return
        }

        if let physicsUnit = pipeline.unit(ofType: PhysicsUnit.self),
           let physicsBody = physicsUnit.createPhysicsBody(for: entity) {
            node.physicsBody = physicsBody
        }

        addNode(node, with: entity)
        bindCamera(to: node, with: entity)

        cache(entity: entity, node: node)
    }

    // MARK: - Post-rendering
    private func prune(nodes: Set<Node>) {
        for node in nodes {
            uncache(node: node)
            remove(node: node)
        }
    }

    // MARK: - Helper Methods
    private func cache(entity: Entity, node: Node) {
        entityNode[entity.id] = node
        renderedNodes[node.coreNode] = node
    }

    private func uncache(node: Node) {
        guard let entityID = node.name else {
            fatalError("remove(node:) called on uncached Entity\n\(String(describing: node))")
        }

        entityNode[entityID] = nil
        renderedNodes[node.coreNode] = nil
    }

    private func addNode(_ node: Node, with entity: Entity) {
        let `static` = target?.hasComponent(ofType: CameraStaticTag.self, in: entity)
        scene?.addChild(node, static: `static` ?? false)
    }

    private func bindCamera(to node: Node, with entity: Entity) {
        if target?.hasComponent(ofType: CameraAnchorTag.self, in: entity) ?? false {
            scene?.bindCamera(to: node)
        }
    }

    private func remove(node: Node) {
        scene?.removeChild(node)
    }

    private func setUpPipeline() {
        pipeline.register(PositionUnit(on: target))
        pipeline.register(PhysicsUnit(on: target))
        pipeline.register(AnimationUnit(on: target))
        pipeline.register(SpriteUnit(on: target))
        pipeline.register(LabelUnit(on: target))
        pipeline.register(CameraUnit(on: target, watching: scene))
        pipeline.register(AreaUnit(on: target, representing: scene))
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
