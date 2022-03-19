//
//  EntitiesManager.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import SpriteKit

class EntitiesManager {
    private var entities = Set<Entity>()
    private var nodeEntityMapping: [SKNode: Entity] = [:]

    func getEntities() -> [Entity] {
        Array(entities)
    }

    func addEntity(_ entity: Entity) {
        entities.insert(entity)
    }

    func removeEntity(_ entity: Entity) {
        entities.remove(entity)
    }

    func getNode(of entity: Entity) -> SKNode? {
        guard let skEntity = entity as? SKEntity,
              let node = skEntity.node else {
            return nil
        }
        return node
    }
    func getEntity(of node: SKNode) -> Entity? {
        nodeEntityMapping[node]
    }
}
