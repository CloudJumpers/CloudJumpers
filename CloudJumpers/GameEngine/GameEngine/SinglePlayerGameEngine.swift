//
//  SinglePlayerGameEngine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import CoreGraphics
import SpriteKit

class SinglePlayerGameEngine: GameEngine {

    var entitiesManager: EntitiesManager
    var eventManager: EventManager
    var touchableManager: TouchableManager
    var contactResolver: ContactResolver

    weak var delegate: GameEngineDelegate?

    private var playerEntity: PlayerEntity

    // System
    let movingSystem: MovingSystem
    let timerSystem: TimerSystem

    init() {
        self.eventManager = EventManager()
        self.entitiesManager = EntitiesManager()
        self.touchableManager = TouchableManager()
        self.contactResolver = ContactResolver(entitiesManager: entitiesManager)

        self.movingSystem = MovingSystem(entitiesManager: entitiesManager)
        self.timerSystem = TimerSystem(entitiesManager: entitiesManager)

        self.playerEntity = PlayerEntity(position: Constants.playerInitialPosition)
        setupEventDelegate()
    }

    func setupEventDelegate() {
        self.contactResolver.eventDelegate = eventManager
        self.touchableManager.eventDelegate = eventManager
    }

    func setupGame(with level: Level) {
        // Using factory to create all object here
        setupPlayer()
        setupTouchables()
        setupTimer()
        setupEnvironment()
    }

    func setupEnvironment() {
        let entities =
        [
           CloudEntity(position: CGPoint(x: 200, y: -200)),
           CloudEntity(position: CGPoint(x: -100, y: -50)),
           CloudEntity(position: CGPoint(x: 200, y: 100)),
           CloudEntity(position: CGPoint(x: -100, y: 250)),
           CloudEntity(position: CGPoint(x: 200, y: 400)),
           CloudEntity(position: CGPoint(x: -100, y: 550)),
           PlatformEntity(position: CGPoint(x: 0, y: 700))
       ]

        for entity in entities {
            addEntity(entity)
        }
    }

    private func setupPlayer() {
        addPlayer(playerEntity)
    }

    private func setupTouchables() {
        let joystick = Joystick(associatedEntity: playerEntity)
        let jumpButton = JumpButton(associatedEntity: playerEntity)

        touchableManager.addTouchable(touchable: joystick)
        touchableManager.addTouchable(touchable: jumpButton)
        addControl(joystick.innerstickEntity)
        addControl(joystick.outerstickEntity)
        addControl(jumpButton)
    }

    private func setupTimer() {
        let timer = TimerEntity()
        addControl(timer)

        let timerComponent = TimerComponent(time: Constants.timerInitial)
        timerSystem.addComponent(entity: timer, component: timerComponent)
    }

    func update(_ deltaTime: Double) {
        for event in eventManager.getEvents() {
            handleEvent(event: event)
        }
        eventManager.resetEventQueue()

        movingSystem.update(deltaTime)
        timerSystem.update(deltaTime)

        touchableManager.updateTouchables()
    }

    private func addEntity(_ entity: SKEntity) {
        entitiesManager.addEntity(entity)
        guard let node = entity.node else {
            return
        }
        delegate?.engine(self, addEntityWith: node)
    }

    private func addPlayer(_ player: PlayerEntity) {
        entitiesManager.addEntity(player)
        guard let node = player.node else {
            return
        }
        delegate?.engine(self, addPlayerWith: node)
    }

    private func addControl(_ control: SKEntity) {
        entitiesManager.addEntity(control)
        guard let node = control.node else {
            return
        }
        delegate?.engine(self, addControlWith: node)
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
        let endGameState = TimeTrialGameEndState(playerEndTime: time)
        delegate?.engine(self, didEndGameWith: endGameState)

    }
}
