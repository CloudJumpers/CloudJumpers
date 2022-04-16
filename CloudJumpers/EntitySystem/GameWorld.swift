//
//  GameWorld.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 12/4/22.
//

import Foundation

class GameWorld {
    private var entityManager: EntityManager
    private var systemManager: SystemManager
    private var eventManager: EventManager
    private var renderer: Renderer?
    private var remoteEventHandlers: RemoteEventHandlers

    init(rendersTo scene: Scene?, subscribesTo handlers: RemoteEventHandlers) {
        entityManager = EntityManager()
        systemManager = SystemManager(for: entityManager)
        eventManager = EventManager()
        remoteEventHandlers = handlers
        renderer = Renderer(from: self, to: scene)
        eventManager.dispatcher = self
    }

    func update(within time: TimeInterval) {
        systemManager.update(within: time)
        eventManager.executeAll(in: self)
        renderer?.render()
    }
}

// MARK: - EventModifiable
extension GameWorld: EventModifiable {
    func add(_ entity: Entity) {
        entityManager.add(entity)
    }

    func add(_ event: Event) {
        eventManager.add(event)
    }

    func remove(_ entity: Entity) {
        entityManager.remove(entity)
    }

    func entity(with entityID: EntityID) -> Entity? {
        entityManager.entity(with: entityID)
    }

    func system<T: System>(ofType type: T.Type) -> T? {
        systemManager.system(ofType: T.self)
    }
}

// MARK: - EventDispatcher
extension GameWorld: EventDispatcher {
    func dispatch(_ remoteEvent: RemoteEvent) {
        guard let command = remoteEvent.createDispatchCommand() else {
            return
        }

        remoteEventHandlers.publisher.publishGameEventCommand(command)
    }

    func add(_ effector: Effector) {
        eventManager.add(effector)
    }
}

// MARK: - Simulatable
extension GameWorld: Simulatable {
    func component<T: Component>(ofType type: T.Type, of entity: Entity) -> T? {
        entityManager.component(ofType: T.self, of: entity)
    }

    func hasComponent<T: Component>(ofType type: T.Type, in entity: Entity) -> Bool {
        entityManager.hasComponent(ofType: T.self, in: entity)
    }

    func entitiesToRender() -> [Entity] {
        entityManager.entities
    }

    func handleContact(between entityAID: EntityID, and entityBID: EntityID) {
        guard let entityA = entity(with: entityAID) as? Collidable,
              let entityB = entity(with: entityBID) as? Collidable
        else { fatalError("An unassociated EntityID was present in EntityManager") }

        if let event = entityA.collides(with: entityB) {
            eventManager.add(event)
        }
    }
}

// MARK: - RuleModifiable
extension GameWorld: RuleModifiable {
    func addComponent(_ component: Component, to entity: Entity) {
        entityManager.addComponent(component, to: entity)
    }
    func hasComponent<T>(ofType type: T.Type, in entityWithID: EntityID) -> Bool where T: Component {
        guard let entity = entity(with: entityWithID) else {
            return false
        }
        return hasComponent(ofType: type, in: entity)
    }

    func components<T>(ofType type: T.Type) -> [T] where T: Component {
        entityManager.components(ofType: type)
    }

    func activateSystem<T>(ofType type: T.Type) where T: System {
        guard let system = systemManager.system(ofType: type) else {
            return
        }
        system.active = true
    }

    func deactivateSystem<T>(ofType type: T.Type) where T: System {
        guard let system = systemManager.system(ofType: type) else {
            return
        }
        system.active = false
    }
}

// MARK: - MetricsProvider
extension GameWorld: MetricsProvider {
    func getMetricsUpdate() -> [String: Int] {
        guard let system = systemManager.system(ofType: MetricsSystem.self) else {
             return [:]
        }
        return system.fetchMetrics()
    }
}
