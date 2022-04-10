//
//  Renderer.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 7/4/22.
//

import SpriteKit

typealias NodesMap = [NodeCore: Node]
typealias EntityNodeMap = [EntityID: Node]

class Renderer {
    private unowned var target: Simulatable?
    private var renderedNodes: NodesMap
    private var entityNode: EntityNodeMap
    private var scene: GameScene

    init(from target: Simulatable, to scene: GameScene) {
        renderedNodes = NodesMap()
        entityNode = EntityNodeMap()
        self.target = target
        self.scene = scene
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
        guard let node = entityNode[entity.id],
              let positionComponent = target?.component(ofType: PositionComponent.self, of: entity)
        else { return }

        node.position = positionComponent.position
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

        node.physicsBody?.applyImpulse(physicsComponent.impulse)
    }

    private func updateAnimation(entity: Entity) {
        guard let node = entityNode[entity.id],
              let animationComponent = target?.component(ofType: AnimationComponent.self, of: entity),
              let animation = animationComponent.textures
        else { return }

        node.animate(with: animation, interval: 0.1)
    }

    private func create(entity: Entity) {
        guard let spriteComponent = target?.component(ofType: SpriteComponent.self, of: entity) else {
            return
        }

        let `static` = target?.hasComponent(ofType: CameraStaticTag.self, in: entity)
        let node = Node(texture: spriteComponent.texture, size: spriteComponent.size)
        scene.addChild(node, static: `static` ?? false)
        bindCamera(to: node, with: entity)
    }

    private func bindCamera(to node: Node, with entity: Entity) {
        guard target?.hasComponent(ofType: CameraAnchorTag.self, in: entity) ?? false else {
            return
        }

        scene.bindCamera(to: node)
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
        scene.removeChild(node)
    }
}
