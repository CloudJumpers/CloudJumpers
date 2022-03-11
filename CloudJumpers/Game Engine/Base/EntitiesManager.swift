//
//  EntitiesManager.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import Foundation
import SpriteKit
import Combine

class EntitiesManager {
    private var entities = Set<Entity>()
    private var nodeEntityMapping: [Entity: SKNode] = [:]
    
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
        guard let node = nodeEntityMapping[entity] else {
            return
        }
        nodeEntityMapping.removeValue(forKey: entity)
        removeSubject.send(node)

    }
    
    func addNode(_ node: SKNode, entity: Entity) {
        // Remove previous node first
        removeNode(entity: entity)
        nodeEntityMapping[entity] = node
        addSubject.send(node)
    }
    
    func removeNode(entity: Entity) {
        guard let node = nodeEntityMapping[entity] else {
            return
        }
        nodeEntityMapping.removeValue(forKey: entity)
        removeSubject.send(node)
    }
    
    func getNode(of entity: Entity) -> SKNode? {
        nodeEntityMapping[entity]
    }
}
