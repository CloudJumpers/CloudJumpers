//
//  GameWorld.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 12/4/22.
//

import Foundation

class GameWorld {
    private let entityManager: EntityManager
    private let systemManager: SystemManager
    private let eventManager: EventManager
    private var renderer: Renderer?
    private var remoteEventHandlers: RemoteEventHandlers

    init(rendersTo scene: Scene?, subscribesTo handlers: RemoteEventHandlers) {
        entityManager = EntityManager()
        systemManager = SystemManager()
        eventManager = EventManager()
        remoteEventHandlers = handlers
        renderer = Renderer(from: self, to: scene)

        eventManager.dispatcher = self
        setUpSystems()
    }

    func update(within time: TimeInterval) {
        systemManager.update(within: time)
        eventManager.executeAll(in: self)
        renderer?.render()
    }

    private func setUpSystems() {
        systemManager.register(PositionSystem(for: entityManager))
        systemManager.register(PhysicsSystem(for: entityManager))
        systemManager.register(PlayerStateSystem(for: entityManager, dispatchesVia: self))
        systemManager.register(AnimateSystem(for: entityManager))
        systemManager.register(StandOnSystem(for: entityManager))
        systemManager.register(TimedSystem(for: entityManager))
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
        else { return }

        if let event = entityA.collides(with: entityB) {
            eventManager.add(event)
        }
    }

    func syncPositions(with entityPositionMap: EntityPositionMap) {
        guard let positionSystem = system(ofType: PositionSystem.self) else {
            return
        }

        positionSystem.sync(with: entityPositionMap)
    }

    func syncVelocities(with entityVelocityMap: EntityVelocityMap) {
        guard let physicsSystem = system(ofType: PhysicsSystem.self) else {
            return
        }

        physicsSystem.sync(with: entityVelocityMap)
    }
}

// MARK: - RuleModifiable
extension GameWorld: RuleModifiable {
    func component<T: Component>(ofType type: T.Type, of entityWithID: EntityID) -> T? {
        guard let entity = entity(with: entityWithID) else {
            return nil
        }
        return entityManager.component(ofType: T.self, of: entity)
    }
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
