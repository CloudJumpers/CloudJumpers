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

    private var entitiesMap: EntityMap
    private var componentsMap: ComponentMap
    private var entitiesComponents: EntityComponentMap

    init() {
        entitiesMap = EntityMap()
        componentsMap = ComponentMap()
        entitiesComponents = EntityComponentMap()
    }

    // MARK: - Entity Modifiers
    var entities: [Entity] {
        Array(entitiesMap.values)
    }

    func add(_ entity: Entity) {
        entitiesMap[entity.id] = entity
        setUpAndAdd(entity)
    }

    func remove(_ entity: Entity) {
        entitiesMap[entity.id] = nil
        removeComponents(of: entity)
    }

    func remove(withID entityID: EntityID) {
        guard let entity = entity(with: entityID) else {
            return
        }

        remove(entity)
    }

    func entity(with entityID: EntityID) -> Entity? {
        entitiesMap[entityID]
    }

    // MARK: - Component Modifiers
    func component<T: Component>(ofType type: T.Type, of entity: Entity) -> T? {
        guard let componentIds = entitiesComponents[entity.id] else {
            return nil
        }

        for componentId in componentIds {
            guard let component = componentsMap[componentId] else {
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
        componentsMap.values.compactMap { $0 as? T }
    }

    func addComponent(_ component: Component, to entity: Entity) {
        component.entity = entity
        componentsMap[component.id] = component
        entitiesComponents[entity.id]?.insert(component.id)
    }

    func removeComponent<T: Component>(ofType type: T.Type, from entity: Entity) {
        guard let component = component(ofType: T.self, of: entity) else {
            return
        }

        componentsMap[component.id] = nil
        entitiesComponents[entity.id]?.remove(component.id)
    }

    // MARK: - Helper Methods
    private func setUpAndAdd(_ entity: Entity) {
        entitiesComponents[entity.id] = []
        entity.setUpAndAdd(to: self)
    }

    private func removeComponents(of entity: Entity) {
        if let componentIds = entitiesComponents[entity.id] {
            for componentId in componentIds {
                componentsMap[componentId] = nil
            }
        }

        entitiesComponents[entity.id] = nil
        entitiesMap[entity.id] = nil
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
