//
//  PhysicsSystem.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation

class CollisionSystem: System {
    let componentDict: [GameEntity: CollisionComponent] = [:]
    func addComponent(entity: GameEntity, component: Component) {
        // Collision with new skNode?
    }
    
    func removeComponent(entity: GameEntity) {
        // Remove based on rendering ?
    }
    
    func update(_ deltaTime: Double) {
        // Update game physics
    }
}
