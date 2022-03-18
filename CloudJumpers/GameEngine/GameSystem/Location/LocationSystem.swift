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
            guard entity.type == .player,
                  let component = entityComponentMapping[entity]
            else {
                continue
            }
            switch component.location {
            case .on(entity: let entity):
                if entity.type == .platform {
                    eventManager?.eventsQueue.append(Event(type: .gameEnd))
                }
            default:
                continue
            }
        }
    }
}
