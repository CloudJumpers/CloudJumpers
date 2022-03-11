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
    
    private var entitiesComponentMapping: [Entity: RenderingComponent] = [:]

    
    init (entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
    }
    
    func addComponent(entity: Entity, component: Component) {
        guard let renderingComponent = component as? RenderingComponent else {
            return
        }
        entitiesComponentMapping[entity] = renderingComponent
    }
    
    
    func update(_ deltaTime: Double) {
        for entity in entitiesComponentMapping.keys {
            guard let component = entitiesComponentMapping[entity],
                  component.isUpdating
            else {
                return
            }
            let newNode = SKNodeFactory.createSKSpriteNode(type: component.type)
            entitiesManager?.addNode(newNode, entity: entity)
        }
        // Update game physics
    }
}
