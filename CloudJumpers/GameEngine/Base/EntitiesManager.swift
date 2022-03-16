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
    private var entityNodeMapping: [Entity: SKNode] = [:]
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
    }

    func removeEntity(_ entity: Entity) {
        entities.remove(entity)
        guard let node = entityNodeMapping[entity] else {
            return
        }
        entityNodeMapping.removeValue(forKey: entity)
        removeSubject.send(node)

    }

    func addNode(_ node: SKNode, entity: Entity) {
        // Remove previous node first
        removeNode(entity: entity)
        entityNodeMapping[entity] = node
        nodeEntityMapping[node] = entity
        addSubject.send(node)
    }

    func removeNode(entity: Entity) {
        guard let node = entityNodeMapping[entity] else {
            return
        }
        entityNodeMapping.removeValue(forKey: entity)
        nodeEntityMapping.removeValue(forKey: node)
        removeSubject.send(node)
    }

    func getNode(of entity: Entity) -> SKNode? {
        entityNodeMapping[entity]
    }
    func getEntity(of node: SKNode) -> Entity? {
        nodeEntityMapping[node]
    }
}
