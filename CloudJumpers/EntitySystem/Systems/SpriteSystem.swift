//
//  SpriteSystem.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class SpriteSystem: System {
    unowned var manager: EntityManager?
    unowned var associatedEntity: Entity?
    unowned var delegate: SpriteSystemDelegate?

    private var sprites: Set<EntityID> = []

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    convenience init(for manager: EntityManager, rendersTo delegate: SpriteSystemDelegate) {
        self.init(for: manager)
        self.delegate = delegate
    }

    // MARK: - System Update
    func update(within time: CGFloat) {
        guard let manager = manager else {
            return
        }

        for spriteComponent in manager.components(ofType: SpriteComponent.self) {
            guard let entity = spriteComponent.entity else {
                fatalError("SpriteComponent does not contain reference to its Entity")
            }

            updateNode(spriteComponent.node, with: entity)
        }
    }

    private func updateNode(_ node: SKNode, with entity: Entity) {
        synchronizeSprite(node, with: entity)
        updateAnimation(of: node, with: entity)
        updateTimed(of: node, with: entity)
    }

    private func updateAddedEntities() {
        guard let manager = manager else {
            return
        }

        for entityID in addedEntity {
            guard let entity = manager.entity(with: entityID),
                  let spriteComponent = manager.component(ofType: SpriteComponent.self, of: entity) else {
                addedEntity.remove(entityID)
                continue
            }

            guard let powerUpEffect = entity as? PowerUpEffect,
                  let timedComponent = manager.component(ofType: TimedComponent.self, of: entity)  else {
                continue
            }

            // animation to fade power-up effect
            let node = spriteComponent.node
            let time = timedComponent.time
            node.alpha = (Constants.powerUpEffectDuration - time) / Constants.powerUpEffectDuration

            if powerUpEffect.shouldRemoveEffect(manager: manager) {
                spriteComponent.removeNodeFromScene = true
            }
        }
    }

    // TODO: definitely have to refactor this
    private func updateInventoryItems() {
        guard let manager = manager else {
            return
        }

        guard let entity = associatedEntity as? Player,
              let inventoryComponent = manager.component(ofType: InventoryComponent.self, of: entity)
        else { return }

        var position = Constants.initialPowerUpQueuePosition
        for inventoryItemID in inventoryComponent.inventory.iterable {
            guard let inventoryEntity = manager.entity(with: inventoryItemID),
                  let spriteComponent = manager.component(ofType: SpriteComponent.self, of: inventoryEntity)
            else { continue }

            removeNodeFromScene(inventoryEntity)

            spriteComponent.node.position = position
            spriteComponent.node.physicsBody = nil

            addNodeToScene(inventoryEntity)

            position.x += Constants.powerUpQueueXInterval
        }

    }

    // MARK: - Per-component Updates
    func updateTimed(of node: SKNode, with entity: Entity) {
        // TODO: Generalise this to support more than just SKLabelNode
        guard let timedComponent = manager?.component(ofType: TimedComponent.self, of: entity),
              let labelNode = node as? SKLabelNode
        else { return }

        labelNode.text = String(format: "%.1f", timedComponent.time)
    }

    func updateAnimation(of node: SKNode, with entity: Entity) {
        guard let animationComponent = manager?.component(ofType: AnimationComponent.self, of: entity) else {
            return
        }

        let texture = animationComponent.texture.of(animationComponent.kind)

        if node.action(forKey: animationComponent.kind.name) == nil {
            node.removeAllActions()
            node.run(.repeatForever(.animate(
                with: texture,
                timePerFrame: 0.1,
                resize: false,
                restore: true)),
            withKey: animationComponent.kind.name)
        }
    }

    // MARK: - Rendering Lifecycle
    private func synchronizeSprite(_ node: SKNode, with entity: Entity) {
        if isEntityNotRendered(entity, node) ||
           isEntityInSpriteSystemNotInParent(entity, node) {
            addSprite(node, with: entity)
        } else if isEntityInParentNotInSpriteSystem(entity, node) {
            removeSprite(node, with: entity)
        }
    }

    private func addSprite(_ node: SKNode, with entity: Entity) {
        let `static` = manager?.hasComponent(ofType: CameraStaticTag.self, in: entity)
        delegate?.spriteSystem(self, addNode: node, static: `static` ?? false)
        bindCameraToSprite(node, with: entity)

        sprites.insert(entity.id)
    }

    private func removeSprite(_ node: SKNode, with entity: Entity) {
        node.removeFromParent()

        sprites.remove(entity.id)
    }

    private func isEntityNotRendered(_ entity: Entity, _ node: SKNode) -> Bool {
        !sprites.contains(entity.id) && node.parent == nil
    }

    private func isEntityInSpriteSystemNotInParent(_ entity: Entity, _ node: SKNode) -> Bool {
        sprites.contains(entity.id) && node.parent == nil
    }

    private func isEntityInParentNotInSpriteSystem(_ entity: Entity, _ node: SKNode) -> Bool {
        node.parent != nil && !sprites.contains(entity.id)
    }

    private func bindCameraToSprite(_ node: SKNode, with entity: Entity) {
        guard manager?.hasComponent(ofType: CameraAnchorTag.self, in: entity) ?? false else {
            return
        }

        delegate?.spriteSystem(self, bindCameraTo: node)
    }
}
