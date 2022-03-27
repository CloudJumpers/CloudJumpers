//
//  SpriteSystem.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class SpriteSystem: System {
    unowned var manager: EntityManager?
    unowned var gameEngine: GameEngine?

    private var addedEntity: Set<EntityID> = []

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        updateAddedEntities()
        addNewEntities()
        updateTimedEntities()
    }

    // TODO: refactor
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

            if spriteComponent.removeNodeFromScene {
                removeNodeFromScene(entity)
                spriteComponent.setRemoveNodeFromScene(false)
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
                removeNodeFromScene(entity)
                manager.remove(entity)
                addedEntity.remove(entityID)
            }
        }
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
              let gameEngine = gameEngine else {
            return
        }

        let node = spriteComponent.node

        switch spriteComponent.cameraBind {
        case .normalBind:
            gameEngine.delegate?.engine(gameEngine, addEntityWith: node)
        case .anchorBind:
            gameEngine.delegate?.engine(gameEngine, addPlayerWith: node)
        case .staticBind:
            gameEngine.delegate?.engine(gameEngine, addControlWith: node)
        }
    }

    private func removeNodeFromScene(_ entity: Entity) {
        guard let entityManager = manager,
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity),
              let gameEngine = gameEngine else {
            return
        }

        let node = spriteComponent.node

        gameEngine.delegate?.engine(gameEngine, removeEntityFrom: node)
    }
}
