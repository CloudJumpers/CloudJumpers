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
    
    private var entityComponentMapping: [Entity: RenderingComponent] = [:]

    
    init (entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
    }
    
    func addComponent(entity: Entity, component: Component) {
        guard let renderingComponent = component as? RenderingComponent else {
            return
        }
        entityComponentMapping[entity] = renderingComponent
    }
    
    
    func update(_ deltaTime: Double) {
        for entity in entityComponentMapping.keys {
            guard let component = entityComponentMapping[entity],
                  component.isUpdating
            else {
                return
            }
            let newNode = SKNodeFactory.createSKSpriteNode(type: component.type)
            entitiesManager?.addNode(newNode, entity: entity)
            component.isUpdating = false
        }
        // Update game physics
    }
}
