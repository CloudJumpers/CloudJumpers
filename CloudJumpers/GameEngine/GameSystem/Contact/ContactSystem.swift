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
                    event = handleBeginContact(entityA: component.entityA,
                                               entityB: component.entityB)
                case .end:
                    event = handleEndContact(entityA: component.entityA,
                                             entityB: component.entityB)
                }
                if let event = event {
                    eventManager?.eventsQueue.append(event)
                }
            }
        }
        entityComponentMapping.removeAll()
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

    private func handleEndContact(entityA: Entity, entityB: Entity) -> Event? {

        if entityA.type == .player && (entityB.type == .cloud || entityB.type == .platform) {
            return Event(type: .changeLocation(entity: entityA, location: .air))
        }
        if entityB.type == .player && (entityA.type == .cloud || entityA.type == .platform) {
            return Event(type: .changeLocation(entity: entityB, location: .air))
        }
        return nil
    }

    private func handleBeginContact(entityA: Entity, entityB: Entity) -> Event? {
        if entityA.type == .player && (entityB.type == .cloud || entityB.type == .platform) {
            return Event(type: .changeLocation(entity: entityA, location: .on(entity: entityB)))
        }
        if entityB.type == .player && (entityA.type == .cloud || entityA.type == .platform) {
            return Event(type: .changeLocation(entity: entityB, location: .on(entity: entityA)))
        }
        return nil
    }

}
