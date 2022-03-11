//
//  PhysicsSystem.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation

class CollisionSystem: System {

    
    weak var entitiesManager: EntitiesManager?
    
    init (entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
    }
    
    func update(_ deltaTime: Double) {
        // Update game physics
    }
    
    func addComponent(entity: Entity, component: Component) {
        guard let collisionComponent = component as? CollisionComponent else {
            return
        }
        entitiesManager?.addComponent(collisionComponent, to: entity)
    }
}
