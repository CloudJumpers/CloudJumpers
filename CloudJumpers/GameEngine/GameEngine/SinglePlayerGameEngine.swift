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
    weak var stateMachine: StateMachine?
    var entitiesManager: EntitiesManager
    var eventManager: EventManager
    var touchableManager: TouchableManager
    var contactResolver: ContactResolver

    var addNodePublisher: AnyPublisher<SKNode, Never> {
        entitiesManager.addPublisher
    }

    var removeNodePublisher: AnyPublisher<SKNode, Never> {
        entitiesManager.removePublisher
    }

    var gameState: GameState

    private var playerEntity: PlayerEntity

    // System
    let movingSystem: MovingSystem
    let timerSystem: TimerSystem

    init(stateMachine: StateMachine) {
        self.stateMachine = stateMachine
        self.eventManager = EventManager()
        self.entitiesManager = EntitiesManager()

        self.touchableManager = TouchableManager(eventManager: eventManager)
        self.contactResolver = ContactResolver(entitiesManager: entitiesManager,
                                               eventManager: eventManager)

        self.movingSystem = MovingSystem(entitiesManager: entitiesManager)

        self.timerSystem = TimerSystem(entitiesManager: entitiesManager)

        self.playerEntity = PlayerEntity(position: Constants.playerInitialPosition)
        self.gameState = .playing

    }

    func setupGame(with level: Level) {
        // Using factory to create all object here
        setupPlayer()
        setupTouchables()
        setupTimer()
        setupEnvironment()

    }

    func setupEnvironment() {
        let testCloud = CloudEntity(position: CGPoint(x: -10, y: 70))
        entitiesManager.addEntity(testCloud)

    }

    private func setupPlayer() {
        entitiesManager.addEntity(self.playerEntity)
    }

    private func setupTouchables() {
        let joystick = Joystick(associatedEntity: playerEntity)
        let jumpButton = JumpButton(associatedEntity: playerEntity)

        touchableManager.addTouchable(touchable: joystick)
        touchableManager.addTouchable(touchable: jumpButton)
        entitiesManager.addEntity(joystick.innerstickEntity)
        entitiesManager.addEntity(joystick.outerstickEntity)
        entitiesManager.addEntity(jumpButton)
    }

    private func setupTimer() {
        let timer = TimerEntity()
        entitiesManager.addEntity(timer)
        let timerComponent = TimerComponent(time: Constants.timerInitial)
        timerSystem.addComponent(entity: timer, component: timerComponent)

    }

    func update(_ deltaTime: Double) {

        for event in eventManager.eventsQueue {
            handleEvent(event: event)
            eventManager.eventsQueue.remove(at: 0)
        }

        movingSystem.update(deltaTime)
        timerSystem.update(deltaTime)

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
        case .gameEnd:
            handleGameEnd()
        }
    }

    private func handleMoveEvent(entity: Entity, by distance: CGVector) {
        let movingComponent = MovingComponent(movement: .move(distance: distance))
        movingSystem.addComponent(entity: entity, component: movingComponent)
    }

    private func handleJumpEvent(entity: Entity) {
        let movingComponent = MovingComponent(movement: .jump(impulse: Constants.jumpImpulse))
        movingSystem.addComponent(entity: playerEntity, component: movingComponent)

        stateMachine?.transition(to: .timeTrialEnd(time: 10.0))
    }

    private func handleGameEnd() {
        let time = timerSystem.getTime()
        stateMachine?.transition(to: .timeTrialEnd(time: time))
    }

}
