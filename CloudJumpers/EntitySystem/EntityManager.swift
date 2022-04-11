//
//  EntityManager.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import Foundation

class EntityManager {
    typealias EntityMap = [EntityID: Entity]
    typealias ComponentMap = [ComponentID: Component]
    typealias EntityComponentMap = [EntityID: Set<ComponentID>]

    private var entities: EntityMap
    private var components: ComponentMap
    private var entitiesComponents: EntityComponentMap
    private var systemManager: SystemManager
    private var eventManager: EventManager

    var subscriber: GameEventSubscriber?
    var publisher: GameEventPublisher?

    init() {
        entities = EntityMap()
        components = ComponentMap()
        entitiesComponents = EntityComponentMap()
        systemManager = SystemManager()
        eventManager = EventManager()
    }

    // MARK: - Lifecycle Methods
    func update(within time: TimeInterval) {
        systemManager.update(within: time, in: self)
        eventManager.executeAll(in: self)
    }

    // MARK: - Entity Modifiers
    func add(_ entity: Entity) {
        entities[entity.id] = entity
        setUpAndAdd(entity)
    }

    func remove(_ entity: Entity) {
        entities[entity.id] = nil
        removeComponents(of: entity)
    }

    func remove(withID entityID: EntityID) {
        guard let entity = entity(with: entityID) else {
            return
        }

        remove(entity)
    }

    func getEntities() -> [Entity] {
        Array(entities.values)
    }

    func entity(with entityID: EntityID) -> Entity? {
        entities[entityID]
    }

    // MARK: - Component Modifiers
    func component<T: Component>(ofType type: T.Type, of entity: Entity) -> T? {
        guard let componentIds = entitiesComponents[entity.id] else {
            return nil
        }

        for componentId in componentIds {
            guard let component = components[componentId] else {
                fatalError("Component ID does not have a matching Component")
            }

            guard let component = component as? T else {
                continue
            }

            return component
        }

        return nil
    }

    func component<T: Component>(ofType type: T.Type, of entityID: EntityID) -> T? {
        guard let entity = entity(with: entityID) else {
            return nil
        }
        return component(ofType: type, of: entity)
    }

    func hasComponent<T: Component>(ofType type: T.Type, in entity: Entity) -> Bool {
        component(ofType: T.self, of: entity) != nil
    }

    func components<T: Component>(ofType type: T.Type) -> [T] {
        components.values.compactMap { $0 as? T }
    }

    func addComponent(_ component: Component, to entity: Entity) {
        component.entity = entity
        components[component.id] = component
        entitiesComponents[entity.id]?.insert(component.id)
    }

    func removeComponent<T: Component>(ofType type: T.Type, from entity: Entity) {
        guard let component = component(ofType: T.self, of: entity) else {
            return
        }

        components[component.id] = nil
        entitiesComponents[entity.id]?.remove(component.id)
    }

    private func setUpAndAdd(_ entity: Entity) {
        entitiesComponents[entity.id] = []
        entity.setUpAndAdd(to: self)
    }

    private func removeComponents(of entity: Entity) {
        if let componentIds = entitiesComponents[entity.id] {
            for componentId in componentIds {
                components[componentId] = nil
            }
        }

        entitiesComponents[entity.id] = nil
        entities[entity.id] = nil
    }
}

// MARK: - EntityID and ComponentID Generators
extension EntityManager {
    static var newEntityID: EntityID {
        UUID().uuidString
    }

    static var newComponentID: ComponentID {
        UUID().uuidString
    }
}

// MARK: - EventModifiable
extension EntityManager: EventModifiable {
    func add(_ event: Event) {
        eventManager.add(event)
    }

    func system<T: System>(ofType type: T.Type) -> T? {
        systemManager.system(ofType: T.self)
    }
}

// MARK: - EventDispatcher
extension EntityManager: EventDispatcher {
}

// MARK: - Simulatable
extension EntityManager: Simulatable {
    func entitiesToRender() -> [Entity] {
        Array(entities.values)
    }

    func handleContact(between entityAID: EntityID, and entityBID: EntityID) {
        guard let entityA = entity(with: entityAID),
              let entityB = entity(with: entityBID)
        else { fatalError("An unassociated EntityID was present in EntityManager") }

        if let event = entityA.collides(with: entityB) {
            eventManager.add(event)
        }
    }
}
