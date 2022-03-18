//
//  EntitiesManager.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import SpriteKit
import Combine

class EntitiesManager {
    private var entities = Set<Entity>()
    private var nodeEntityMapping: [SKNode: Entity] = [:]

    private let addSubject = PassthroughSubject<SKNode, Never>()
    private let removeSubject = PassthroughSubject<SKNode, Never>()

    var addPublisher: AnyPublisher<SKNode, Never> {
        addSubject.eraseToAnyPublisher()
    }

    var removePublisher: AnyPublisher<SKNode, Never> {
        removeSubject.eraseToAnyPublisher()
    }

    func getEntities() -> [Entity] {
        Array(entities)
    }

    func addEntity(_ entity: Entity) {
        entities.insert(entity)
        guard let skEntity = entity as? SKEntity,
              let node = skEntity.node else {
            return
        }
        addSubject.send(node)
    }

    func removeEntity(_ entity: Entity) {
        entities.remove(entity)
        guard let skEntity = entity as? SKEntity,
              let node = skEntity.node else {
            return
        }
        removeSubject.send(node)
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
