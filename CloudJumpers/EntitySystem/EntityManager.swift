//
//  EntityManager.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import Foundation

class EntityManager {
    typealias EntitiesMap = [EntityID: Entity]
    typealias ComponentsMap = [ComponentID: Component]
    typealias EntitiesComponentsMap = [EntityID: Set<ComponentID>]

    private var entities: EntitiesMap
    private var components: ComponentsMap
    private var entitiesComponents: EntitiesComponentsMap

    init() {
        entities = [:]
        components = [:]
        entitiesComponents = [:]
    }

    var iterableEntities: EntitiesMap.Values {
        entities.values
    }

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

    func entity(with entityID: EntityID) -> Entity? {
        entities[entityID]
    }

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

// MARK: - EntityID and ComponentID Generation
extension EntityManager {
    static var newEntityID: EntityID {
        UUID().uuidString
    }

    static var newComponentID: ComponentID {
        UUID().uuidString
    }
}
