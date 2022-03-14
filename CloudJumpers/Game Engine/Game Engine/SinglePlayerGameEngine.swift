//
//  SinglePlayerGameEngine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation
import Combine

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
        eventSubscription = inputManager.inputPublisher.sink {[weak self] input in
            self?.eventManager.eventsQueue.append(Event(type: .input(info: input)))
        }

        addNodeSubscription = entitiesManager.addPublisher.sink {[weak self] node in
            self?.gameScene?.addChild(node)
        }

        removeNodeSubscription = entitiesManager.removePublisher.sink {[weak self] node in
            node.removeAllChildren()
            node.removeFromParent()
        }
    }
    
    func setupGame(level: Level) {
        // Usinge factory to create all object here
        setupPlayer()
        setupUI()
    }
    
    func setupPlayer() {
        let player = PlayerComponent(position: Constants.playerInitialPosition)
        playerEntity = player.activate(renderingSystem: renderingSystem)
    }
    
    func setupUI() {
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
    

    func handleEvent(event: Event) {
        switch(event.type) {
        case .input(let info):
            switch (info.inputType) {
            case .move(let entity, let by):
                let movingComponent = MovingComponent(distance: by)
                movingSystem.addComponent(entity: entity, component: movingComponent)
            case .touchBegan(let location):
                for touchable in touchables {
                    touchable.handleTouchBegan(touchLocation: location)
                }
            case .touchMoved(let location):
                for touchable in touchables {
                    touchable.handleTouchMoved(touchLocation: location)
                }
            case .touchEnded(let location):
                for touchable in touchables {
                    touchable.handleTouchEnded(touchLocation: location)
                }
            default:
                return
            }
        default:
            return
        }
    }
    
    func updateTouchables() {
        for touchable in touchables {
            touchable.update()
        }
    }
}
