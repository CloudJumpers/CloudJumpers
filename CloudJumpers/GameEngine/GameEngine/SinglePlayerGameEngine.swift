//
//  SinglePlayerGameEngine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import CoreGraphics
import SpriteKit

class SinglePlayerGameEngine: GameEngine {
    weak var stateMachine: StateMachine?
    var entitiesManager: EntitiesManager
    var eventManager: EventManager
    var touchableManager: TouchableManager
    var contactResolver: ContactResolver

    var gameState: GameState
    weak var delegate: GameEngineDelegate?

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
        // should read from a file?
        let cloud1 = CloudEntity(position: CGPoint(x: 173, y: -300))
        entitiesManager.addEntity(cloud1)

        let cloud2 = CloudEntity(position: CGPoint(x: -50, y: -220))
        entitiesManager.addEntity(cloud2)

        let platform = PlatformEntity(position: CGPoint(x: 0, y: -150))
        entitiesManager.addEntity(platform)

        guard let node = testCloud.node else {
            return
        }
        delegate?.engine(self, addEntityWith: node)
    }

    private func setupPlayer() {
        entitiesManager.addEntity(playerEntity)

        guard let node = playerEntity.node else {
            return
        }
        delegate?.engine(self, addPlayerWith: node)
    }

    private func setupTouchables() {
        let joystick = Joystick(associatedEntity: playerEntity)
        let jumpButton = JumpButton(associatedEntity: playerEntity)

        touchableManager.addTouchable(touchable: joystick)
        touchableManager.addTouchable(touchable: jumpButton)
        entitiesManager.addEntity(joystick.innerstickEntity)
        entitiesManager.addEntity(joystick.outerstickEntity)
        entitiesManager.addEntity(jumpButton)

        guard let innerStickNode = joystick.innerstickEntity.node,
              let outerStickNode = joystick.outerstickEntity.node,
              let jumpButtonNode = jumpButton.node
        else { return }
        delegate?.engine(self, addControlWith: innerStickNode)
        delegate?.engine(self, addControlWith: outerStickNode)
        delegate?.engine(self, addControlWith: jumpButtonNode)
    }

    private func setupTimer() {
        let timer = TimerEntity()

        entitiesManager.addEntity(timer)

        let timerComponent = TimerComponent(time: Constants.timerInitial)
        timerSystem.addComponent(entity: timer, component: timerComponent)

        guard let node = timer.node else {
            return
        }
        delegate?.engine(self, addControlWith: node)
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
    }

    private func handleGameEnd() {
        let time = timerSystem.getTime()
        stateMachine?.transition(to: .timeTrialEnd(time: time))
    }
}
