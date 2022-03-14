//
//  SinglePlayerGameEngine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation
import Combine
import CoreGraphics

class SinglePlayerGameEngine: GameEngine {
    var entitiesManager: EntitiesManager
    var eventManager: EventManager
    var inputManager: InputManager

    weak var gameScene: GameScene?

    private var eventSubscription: AnyCancellable?
    private var addNodeSubscription: AnyCancellable?
    private var removeNodeSubscription: AnyCancellable?

    private var playerEntity: Entity!
    private var touchables: [Touchable] = []

    // System
    let renderingSystem: RenderingSystem
    let collisionSystem: CollisionSystem
    let movingSystem: MovingSystem

    init(gameScene: GameScene, level: Level) {
        self.gameScene = gameScene
        self.entitiesManager = EntitiesManager()
        self.eventManager = EventManager()
        self.inputManager = InputManager()

        self.renderingSystem = RenderingSystem(entitiesManager: entitiesManager)
        self.collisionSystem = CollisionSystem(entitiesManager: entitiesManager)
        self.movingSystem = MovingSystem(entitiesManager: entitiesManager)

        createSubscribers()
        setupGame(level: level)
    }

    func createSubscribers() {
        eventSubscription = inputManager.inputPublisher.sink { [weak self] input in
            self?.eventManager.eventsQueue.append(Event(type: .input(info: input)))
        }

        addNodeSubscription = entitiesManager.addPublisher.sink { [weak self] node in
            self?.gameScene?.addChild(node)
        }

        removeNodeSubscription = entitiesManager.removePublisher.sink { node in
            node.removeAllChildren()
            node.removeFromParent()
        }
    }

    func setupGame(level: Level) {
        // Usinge factory to create all object here
        setupPlayer()
        setupUI()
    }

    private func setupPlayer() {
        let player = PlayerComponent(position: Constants.playerInitialPosition)
        playerEntity = player.activate(renderingSystem: renderingSystem)
    }

    private func setupUI() {
        let joystick = Joystick(gameEngine: self, associatedEntity: playerEntity)
        _ = joystick.activate(renderingSystem: renderingSystem)
        touchables.append(joystick)
    }

    func update(_ deltaTime: Double) {
        for event in eventManager.eventsQueue {
            handleEvent(event: event)
            eventManager.eventsQueue.remove(at: 0)
        }

        movingSystem.update(deltaTime)
        collisionSystem.update(deltaTime)
        renderingSystem.update(deltaTime)

        updateTouchables()
    }

    private func handleEvent(event: Event) {
        switch event.type {
        case .input(let info):
            switch info.inputType {
            case let .move(entity, by):
                handleMoveEvent(entity: entity, by: by)
            case .touchBegan(let location):
                handleTouchBeganEvent(location: location)
            case .touchMoved(let location):
                handleTouchMovedEvent(location: location)
            case .touchEnded(let location):
                handleTouchEndedEvent(location: location)
            default:
                return
            }
        default:
            return
        }
    }

    private func handleMoveEvent(entity: Entity, by: CGVector) {
        let movingComponent = MovingComponent(distance: by)
        movingSystem.addComponent(entity: entity, component: movingComponent)
    }

    private func handleTouchBeganEvent(location: CGPoint) {
        for touchable in touchables {
            touchable.handleTouchBegan(touchLocation: location)
        }
    }

    private func handleTouchMovedEvent(location: CGPoint) {
        for touchable in touchables {
            touchable.handleTouchMoved(touchLocation: location)
        }
    }

    private func handleTouchEndedEvent(location: CGPoint) {
        for touchable in touchables {
            touchable.handleTouchEnded(touchLocation: location)
        }
    }

    private func updateTouchables() {
        for touchable in touchables {
            touchable.update()
        }
    }
}
