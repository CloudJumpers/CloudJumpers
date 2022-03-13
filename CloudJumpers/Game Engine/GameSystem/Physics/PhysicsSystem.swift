//
//  PhysicsSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/12/22.
//

import Foundation


class PhysicsSystem: System {

    weak var entitiesManager: EntitiesManager?
    
    private var entityComponentMapping: [Entity: PhysicsComponent] = [:]

    
    init (entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
    }
    
    func addComponent(entity: Entity, component: Component) {
        guard let physicsComponent = component as? PhysicsComponent else {
            return
        }
        entityComponentMapping[entity] = physicsComponent
    }
    
    
    func update(_ deltaTime: Double) {
        for entity in entityComponentMapping.keys {
            guard let component = entityComponentMapping[entity],
                  let node = entitiesManager?.getNode(of: entity),
                  component.isUpdating
            else {
                return
            }
            let physicsBody = SKPhysicsBodyFactory.createPhysicsBody(shape: component.shape)
            node.physicsBody = physicsBody
            component.isUpdating = false
        }
    }
}