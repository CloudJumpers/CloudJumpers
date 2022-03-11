//
//  RenderingSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/10/22.
//

import Foundation
import SpriteKit

class RenderingSystem: System {

    weak var entitiesManager: EntitiesManager?
    init (entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
    }
    
    func addComponent(entity: Entity, component: Component) {
        guard let renderingComponent = component as? RenderingComponent else {
            return
        }
        entitiesManager?.addComponent(renderingComponent, to: entity)
    }
    
    
    func update(_ deltaTime: Double) {
        // Update game physics
    }
}
