//
//  LocationSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/16/22.
//

import Foundation

class LocationSystem: System {

    weak var entitiesManager: EntitiesManager?
    weak var eventManager: EventManager?

    private var entityComponentMapping: [Entity: LocationComponent] = [:]

    init (entitiesManager: EntitiesManager, eventManager: EventManager) {
        self.entitiesManager = entitiesManager
        self.eventManager = eventManager
    }

    func addComponent(entity: Entity, component: Component) {
        guard let locationComponent = component as? LocationComponent else {
            return
        }
        entityComponentMapping[entity] = locationComponent
    }

    func update(_ deltaTime: Double) {
        for entity in entityComponentMapping.keys {
            // check location based logic
            // If reached top platform -> Win
            // Check if two player on same cloud
        }
    }
}
