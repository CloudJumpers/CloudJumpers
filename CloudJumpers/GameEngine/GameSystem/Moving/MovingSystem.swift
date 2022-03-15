//
//  MovingSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/12/22.
//

import SpriteKit

class MovingSystem: System {

    weak var entitiesManager: EntitiesManager?

    private var entityComponentMapping: [Entity: [MovingComponent]] = [:]

    init (entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
    }

    func update(_ deltaTime: Double) {
        for entity in entityComponentMapping.keys {
            guard let node = entitiesManager?.getNode(of: entity),
                  let components = entityComponentMapping[entity] else {
                return
            }
            for component in components {
                switch component.movement {
                case let .move(distance):
                    handleMove(node: node, entity: entity, distance: distance)
                case let .jump(impulse):
                    handleJump(node: node, impulse: impulse)
                }
            }

            entityComponentMapping.removeValue(forKey: entity)
        }
    }

    func addComponent(entity: Entity, component: Component) {
        guard let movingComponent = component as? MovingComponent else {
            return
        }
        guard entityComponentMapping[entity] != nil else {
            entityComponentMapping[entity] = [movingComponent]
            return
        }

        entityComponentMapping[entity]!.append(movingComponent)
    }

    private func handleMove(node: SKNode, entity: Entity, distance: CGVector) {
        var distance = distance
        if entity.type == .player {
            distance.dy = 0
        }
        node.position += distance
    }

    private func isJumping(node: SKNode) -> Bool {
        abs(node.physicsBody?.velocity.dy ?? 0.0) > Constants.jumpYTolerance
    }

    private func handleJump(node: SKNode, impulse: CGVector) {
        if !isJumping(node: node) {
            node.physicsBody?.applyImpulse(impulse)
        }
    }
}
