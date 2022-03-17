//
//  SinglePlayerGameEngine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Combine
import CoreGraphics
import SpriteKit

class SinglePlayerGameEngine: GameEngine {
    var entitiesManager: EntitiesManager
    var eventManager: EventManager
    var touchableManager: TouchableManager

    var addNodePublisher: AnyPublisher<SKNode, Never> {
        entitiesManager.addPublisher
    }

    var removeNodePublisher: AnyPublisher<SKNode, Never> {
        entitiesManager.removePublisher
    }

    private var playerEntity: PlayerEntity

    // System
    let renderingSystem: RenderingSystem
    let movingSystem: MovingSystem
    let contactSystem: ContactSystem
    let locationSystem: LocationSystem

    init() {
        self.entitiesManager = EntitiesManager()

        self.eventManager = EventManager()
        self.touchableManager = TouchableManager(eventManager: eventManager)

        self.renderingSystem = RenderingSystem(entitiesManager: entitiesManager)
        self.movingSystem = MovingSystem(entitiesManager: entitiesManager)
        self.contactSystem = ContactSystem(entitiesManager: entitiesManager,
                                           eventManager: eventManager)
        self.locationSystem = LocationSystem(entitiesManager: entitiesManager,
                                             eventManager: eventManager)

        self.playerEntity = PlayerEntity(position: Constants.playerInitialPosition)

    }

    func setupGame(with level: Level) {
        // Using factory to create all object here
        setupPlayer()
        setupTouchables()
    }

    private func setupPlayer() {
        self.playerEntity.activate(renderingSystem: renderingSystem)
    }

    private func setupTouchables() {
        let joystick = Joystick(associatedEntity: playerEntity)
        let jumpButton = JumpButton(associatedEntity: playerEntity)

        touchableManager.addTouchable(touchable: joystick)
        touchableManager.addTouchable(touchable: jumpButton)

        joystick.activate(renderingSystem: renderingSystem)
        jumpButton.activate(renderingSystem: renderingSystem)
    }

    func update(_ deltaTime: Double) {
        for event in eventManager.eventsQueue {
            handleEvent(event: event)
            eventManager.eventsQueue.remove(at: 0)
        }

        movingSystem.update(deltaTime)
        contactSystem.update(deltaTime)
        locationSystem.update(deltaTime)
        renderingSystem.update(deltaTime)

        touchableManager.updateTouchables()
    }

    private func handleEvent(event: Event) {
        // Your handler should not add anything to the event queue, only
        // add to the different systems, which add to the event queue later on update
        switch event.type {
        case .input(let info):
            switch info.inputType {
            case let .move(entity, by):
                handleMoveEvent(entity: entity, by: by)
            case let .jump(entity):
                handleJumpEvent(entity: entity)
            default:
                return
            }
        case let .contact( nodeA, nodeB):
            handleBeginContactEvent(nodeA: nodeA, nodeB: nodeB)
        case let .endContact(nodeA, nodeB):
            handleEndContactEvent(nodeA: nodeA, nodeB: nodeB)
        case let .changeLocation(entity, location):
            handleChangeLocation(entity: entity, location: location)
        default:
            return
        }
    }

    private func handleMoveEvent(entity: Entity, by distance: CGVector) {
        let movingComponent = MovingComponent(movement: .move(distance: distance))
        movingSystem.addComponent(entity: entity, component: movingComponent)
    }

    private func handleJumpEvent(entity: Entity) {
        let movingComponent = MovingComponent(movement: .jump(impulse: Constants.jumpImpulse))
        movingSystem.addComponent(entity: playerEntity, component: movingComponent)
    }

    private func handleBeginContactEvent(nodeA: SKNode, nodeB: SKNode) {
        guard let entityA = entitiesManager.getEntity(of: nodeA),
              let entityB = entitiesManager.getEntity(of: nodeB),
              entityA.type == .player || entityB.type == .player
        else {
            return
        }
        let contactComponent: ContactComponent
        if entityA.type == .player {
            contactComponent = ContactComponent(entity: entityB, type: .begin)
        } else {
            contactComponent = ContactComponent(entity: entityA, type: .begin)
        }
        contactSystem.addComponent(entity: entityA, component: contactComponent)

    }

    private func handleEndContactEvent(nodeA: SKNode, nodeB: SKNode) {
        guard let entityA = entitiesManager.getEntity(of: nodeA),
              let entityB = entitiesManager.getEntity(of: nodeB),
              entityA.type == .player || entityB.type == .player
        else {
            return
        }
        let contactComponent: ContactComponent
        if entityA.type == .player {
            contactComponent = ContactComponent(entity: entityB, type: .end)
        } else {
            contactComponent = ContactComponent(entity: entityA, type: .end)
        }
        contactSystem.addComponent(entity: entityA, component: contactComponent)
    }

    private func handleChangeLocation(entity: Entity, location: LocationComponent.Location) {
        let locationComponent = LocationComponent(location: location)
        locationSystem.addComponent(entity: entity, component: locationComponent)
    }

}
