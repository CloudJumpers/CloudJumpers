//
//  SpriteSystem.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

// TODO: refactor
class SpriteSystem: System {
    unowned var manager: EntityManager?
    unowned var delegate: GameEngineDelegate?
    unowned var associatedEntity: Entity?

    private var addedEntity: Set<EntityID> = []

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        updateAddedEntities()
        removeEntities()
        addNewEntities()
        updateInventoryItems()
        updateTimedEntities()
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
              let inventoryComponent = manager.component(ofType: InventoryComponent.self, of: entity),
              inventoryComponent.isUpdated else {
            return
        }

        var position = Constants.initialPowerUpQueuePosition
        for inventoryItemID in inventoryComponent.inventory {
            guard let inventoryEntity = manager.entity(with: inventoryItemID),
                  let spriteComponent = manager.component(ofType: SpriteComponent.self, of: inventoryEntity) else {
                continue
            }

            removeNodeFromScene(inventoryEntity)

            spriteComponent.node.position = position
            spriteComponent.cameraBind = .staticBind
            spriteComponent.node.physicsBody = nil

            addNodeToScene(inventoryEntity)

            position.x += Constants.powerUpQueueXInterval
        }

        inventoryComponent.isUpdated = false
    }

    private func addNewEntities() {
        guard let manager = manager else {
            return
        }

        for entity in manager.iterableEntities {
            guard let spriteComponent = manager.component(ofType: SpriteComponent.self, of: entity)
            else {
                continue
            }

            let node = spriteComponent.node
            if !addedEntity.contains(entity.id) {
                addNodeToScene(entity)
                addedEntity.insert(entity.id)
            }

            updateTimed(of: node, with: entity)
        }
    }

    private func removeEntities() {
        guard let manager = manager else {
            return
        }

        for entity in manager.iterableEntities {
            guard let spriteComponent = manager.component(ofType: SpriteComponent.self, of: entity)
            else {
                continue
            }

            if spriteComponent.removeNodeFromScene {
                removeNodeFromScene(entity)
                addedEntity.remove(entity.id)
                manager.remove(entity)
            }
        }
    }

    private func updateTimedEntities() {
        guard let manager = manager else {
            return
        }

        for entity in manager.iterableEntities {
            guard let spriteComponent = manager.component(ofType: SpriteComponent.self, of: entity)
            else {
                continue
            }

            let node = spriteComponent.node
            updateAnimation(of: node, with: entity)
            updateTimed(of: node, with: entity)
        }
    }

    func updateTimed(of node: SKNode, with entity: Entity) {
        // TODO: Generalise this to support more than just SKLabelNode
        guard let timedComponent = manager?.component(ofType: TimedComponent.self, of: entity),
              let labelNode = node as? SKLabelNode
        else { return }

        labelNode.text = String(format: "%.1f", timedComponent.time)
    }

    private func addNodeToScene(_ entity: Entity) {
        guard let entityManager = manager,
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity),
              let delegate = delegate else {
            return
        }

        let node = spriteComponent.node

        switch spriteComponent.cameraBind {
        case .normalBind:
            delegate.engine(addEntityWith: node)
        case .anchorBind:
            delegate.engine(addPlayerWith: node)
        case .staticBind:
            delegate.engine(addControlWith: node)
        }
    }

    private func removeNodeFromScene(_ entity: Entity) {
        guard let entityManager = manager,
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return }

        spriteComponent.node.removeFromParent()
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
}
