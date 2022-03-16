//
//  ContactSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/15/22.
//

import Foundation

class ContactSystem: System {
    private var entityComponentMapping: [Entity: [ContactComponent]] = [:]

    weak var entitiesManager: EntitiesManager?
    weak var eventManager: EventManager?

    init (entitiesManager: EntitiesManager, eventManager: EventManager) {
        self.entitiesManager = entitiesManager
        self.eventManager = eventManager
    }
    func update(_ deltaTime: Double) {
        for entity in entityComponentMapping.keys {
            guard let components = entityComponentMapping[entity] else {
                return
            }
            for component in components {
                var event: Event?
                switch component.contactType {

                case .begin:
                    event = handleBeginContact(main: entity, other: component.entity)
                case .end:
                    event = handleEndContact(main: entity, other: component.entity)
                }
                if let event = event {
                    eventManager?.eventsQueue.append(event)
                }
            }
        }
    }

    func addComponent(entity: Entity, component: Component) {
        guard let contactComponent = component as? ContactComponent else {
            return
        }
        guard entityComponentMapping[entity] != nil else {
            entityComponentMapping[entity] = [contactComponent]
            return
        }

        entityComponentMapping[entity]?.append(contactComponent)
    }

    private func handleEndContact(main entityA: Entity, other entityB: Entity) -> Event? {
        if entityB.type == .cloud || entityB.type == .platform {
            return Event(type: .changeLocation(entity: entityA, location: .air))
        }
        return nil
    }

    private func handleBeginContact(main entityA: Entity, other entityB: Entity) -> Event? {
        if entityB.type == .cloud || entityB.type == .platform {
            return Event(type: .changeLocation(entity: entityA, location: .on(entity: entityB)))
        }
        return nil
    }

}
