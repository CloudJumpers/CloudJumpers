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
        renderer = Renderer(from: self, to: scene)
        remoteEventHandlers = handlers
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
