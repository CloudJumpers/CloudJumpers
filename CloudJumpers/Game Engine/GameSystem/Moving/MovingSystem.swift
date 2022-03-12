//
//  MovingSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/12/22.
//

import Foundation

class MovingSystem: System {
    
    weak var entitiesManager: EntitiesManager?
    
    private var entityComponentMapping: [Entity: MovingComponent] = [:]

    
    init (entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
    }
    
    func update(_ deltaTime: Double) {
        for entity in entityComponentMapping.keys {
            guard let node = entitiesManager?.getNode(of: entity),
                  let component = entityComponentMapping[entity]
            else {
                return
            }
            let movement = component.magnitude * component.direction
            node.physicsBody?.applyImpulse(movement)
        }
    }
    
    func addComponent(entity: Entity, component: Component) {
        guard let movingComponent = component as? MovingComponent else {
            return
        }
        entityComponentMapping[entity] = movingComponent
    }
    
    
}
