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

    private var addedEntity: Set<SKNode> = []
//    private var removeEntity: Set<SKNode> = []

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        guard let manager = manager else {
            return
        }

//        for entity in removeEntity {
//            guard let spriteComponent = manager.component(ofType: SpriteComponent.self, of: entity)
//            else {
//                continue
//            }
//
//            let node = spriteComponent.node
//
//            removeNodeFromScene(entity)
//            addedEntity.remove(node)
//        }

        for entity in manager.iterableEntities {
            guard let spriteComponent = manager.component(ofType: SpriteComponent.self, of: entity)
            else {
                continue
            }

            let node = spriteComponent.node
            if !addedEntity.contains(node) {
                addNodeToScene(entity)
                addedEntity.insert(node)
            }

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

        if entityManager.component(ofType: BindCameraComponent.self, of: entity) != nil {
            gameEngine.delegate?.engine(gameEngine, addPlayerWith: node)
        } else if entityManager.component(ofType: StaticCameraComponent.self, of: entity) != nil {
            gameEngine.delegate?.engine(gameEngine, addControlWith: node)
        } else {
            gameEngine.delegate?.engine(gameEngine, addEntityWith: node)
        }
    }

//    private func removeNodeFromScene(_ entity: Entity) {
//        guard let entityManager = manager,
//              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity),
//              let gameEngine = gameEngine else {
//            return
//        }
//
//        let node = spriteComponent.node
//
//        gameEngine.delegate?.engine(gameEngine, removeEntityFrom: node)
//        if entityManager.component(ofType: BindCameraComponent.self, of: entity) != nil {
//            gameEngine.delegate?.engine(gameEngine, addPlayerWith: node)
//        } else if entityManager.component(ofType: StaticCameraComponent.self, of: entity) != nil {
//            gameEngine.delegate?.engine(gameEngine, addControlWith: node)
//        } else {
//            gameEngine.delegate?.engine(gameEngine, addEntityWith: node)
//        }
//    }
}
