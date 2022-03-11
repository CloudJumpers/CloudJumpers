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
    private var entitiesComponentMapping: [Entity: [Component]] = [:]
    
    private var nodeEntityMapping: [Entity: SKNode] = [:]
    
    private let addSubject = PassthroughSubject<SKNode, Never>()
    private let removeSubject = PassthroughSubject<SKNode, Never>()

    var addPublisher: AnyPublisher<SKNode, Never> {
        addSubject.eraseToAnyPublisher()
    }

    var removePublisher: AnyPublisher<SKNode, Never> {
        removeSubject.eraseToAnyPublisher()
    }
    
    func addComponent<T: Component>(_ component: T, to entity: Entity) {
        
        guard entitiesComponentMapping[entity] != nil else {
            entitiesComponentMapping[entity] = [component]
            return
        }
        entitiesComponentMapping[entity]?.append(component)
    }

    
    func removeEntity(_ entity: Entity) {
        entitiesComponentMapping.removeValue(forKey: entity)
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

    func getComponent<T: Component>(_ type: T.Type, for entity: Entity) -> T? {
        getComponents(type, for: entity).first
    }

    func getComponents<T: Component>(_ type: T.Type, for entity: Entity) -> [T] {
        guard let components = entitiesComponentMapping[entity] else {
            return []
        }
        var result: [T] = []
        for component in components {
            if let typeCastedComponent = component as? T {
                result.append(typeCastedComponent)
            }
        }
        return result
    }
    
    
    
    
}
