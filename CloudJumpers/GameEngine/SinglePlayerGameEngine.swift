//
//  NewGameEngine.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 24/3/22.
//

import SpriteKit

class SinglePlayerGameEngine: GameEngine {
    let entityManager: EntityManager
    let eventManager: EventManager
    let powerUpManager: PowerUpManager
    let contactResolver: ContactResolver
    weak var delegate: GameEngineDelegate?
    var systems: [System]
    var associatedEntity: Entity?

    required init(for delegate: GameEngineDelegate) {
        entityManager = EntityManager()
        eventManager = EventManager()
        powerUpManager = PowerUpManager(associatedEntity: associatedEntity)
        contactResolver = ContactResolver(to: eventManager)
        systems = []
        self.delegate = delegate
        setUpSystems()
    }

    func update(within time: CGFloat) {
        updateEvents()
        updateSystems(within: time)
    }

    func setUpGame() {
        setUpSampleGame()
    }

    private func setUpSystems() {
        systems.append(TimedSystem(for: entityManager))
        systems.append(SpriteSystem(for: entityManager))
    }

    private func updateSystems(within time: CGFloat) {
        for system in systems {
            system.update(within: time)
        }
    }

    // MARK: - Temporary methods to abstract
    private var timer: TimedLabel?

    private func setUpSampleGame() {
        let timer = TimedLabel(at: Constants.timerPosition, initial: Constants.timerInitial)
        let player = Player(at: Constants.playerInitialPosition, texture: .character1)
        let entities: [Entity] = [
            Platform(at: CGPoint(x: 0, y: 700)),
            Freeze(at: CGPoint(x: 200, y: -300)),
            Confuse(at: CGPoint(x: -200, y: -300)),
            Confuse(at: CGPoint(x: 0, y: -200)),
            Cloud(at: CGPoint(x: 200, y: -200)),
            Cloud(at: CGPoint(x: -100, y: -50)),
            Cloud(at: CGPoint(x: 200, y: 100)),
            Cloud(at: CGPoint(x: -100, y: 250)),
            Cloud(at: CGPoint(x: 200, y: 400)),
            Cloud(at: CGPoint(x: -100, y: 550))]

        entityManager.add(timer)
        entityManager.add(player)
        entities.forEach(entityManager.add(_:))

        addNodeToScene(timer, with: delegate?.engine(_:addControlWith:))
        addNodeToScene(player, with: delegate?.engine(_:addPlayerWith:))
        entities.forEach { addNodeToScene($0, with: delegate?.engine(_:addEntityWith:)) }

        self.timer = timer
        associatedEntity = player

        let powerUpsAvailable = [FreezeButton(at: Constants.freezeButtonPosition,
                                              powerUpManager: powerUpManager,
                                              eventManger: eventManager),
                                 ConfuseButton(at: Constants.confuseButtonPosition,
                                               powerUpManager: powerUpManager,
                                               eventManger: eventManager)]
        powerUpManager.initializePowerUp(powerUps: powerUpsAvailable)
    }

    private func addNodeToScene(_ entity: Entity, with method: ((GameEngine, SKNode) -> Void)?) {
        guard let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity) else {
            return
        }

        method?(self, spriteComponent.node)
    }

    private func removeNodeFromScene(_ node: SKNode, with method: ((GameEngine, SKNode) -> Void)?) {
        method?(self, node)
    }

    private func updateEvents() {
        for event in eventManager.getEvents() {
            switch event.type {
            case .gameEnd:
                handleGameEnd()
            case let .getPowerUp(powerUp, powerUpNode):
                handleGetPowerUp(powerUp: powerUp, powerUpNode: powerUpNode)
            case let .activatePowerUp(type, location):
                handlePowerUpActivation(type: type, location: location)
            default:
                return
            }
        }

        eventManager.resetEventQueue()
    }

    private func handleGameEnd() {
        guard let timer = timer,
              let timedComponent = entityManager.component(ofType: TimedComponent.self, of: timer)
        else { return }

        let time = timedComponent.time
        let endGameState = TimeTrialGameEndState(playerEndTime: time)
        delegate?.engine(self, didEndGameWith: endGameState)
    }

    private func handleGetPowerUp(powerUp: PowerUpType, powerUpNode: SKNode) {
        powerUpManager.getPowerUp(powerUp: powerUp)

        guard let name = powerUpNode.name else {
            return
        }

        if let entity = entityManager.entities[name] {
            entityManager.remove(entity)
            removeNodeFromScene(powerUpNode, with: delegate?.engine(_:removeEntityWith:))
        }
    }

    private func handlePowerUpActivation(type: PowerUpType, location: CGPoint) {
        // TODO: disturb other players
        switch type {
        case .freeze:
            let freezeEffect = FreezeEffect(at: location)
            entityManager.add(freezeEffect)
            addNodeToScene(freezeEffect, with: delegate?.engine(_:addEntityWith:))
        case .confuse:
            let confuseEffect = ConfuseEffect(at: location)
            entityManager.add(confuseEffect)
            addNodeToScene(confuseEffect, with: delegate?.engine(_:addEntityWith:))
        }

    }
}

// MARK: - InputResponder
extension SinglePlayerGameEngine: InputResponder {
    func inputMove(by displacement: CGVector) {
        guard let entity = associatedEntity,
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return }

        spriteComponent.node.position += CGVector(dx: displacement.dx, dy: 0)
    }

    func inputJump() {
        guard let entity = associatedEntity,
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity)
        else { return }

        if !isJumping(body: physicsComponent.body) {
            animateJump(entity)
            physicsComponent.body.applyImpulse(Constants.jumpImpulse)
        }
    }

    private func animateJump(_ entity: Entity) {
        guard let animationComponent = entityManager.component(ofType: AnimationComponent.self, of: entity) else {
            return
        }

        animationComponent.kind = .jumping
    }

    private func isJumping(body: SKPhysicsBody) -> Bool {
        abs(body.velocity.dy) > Constants.jumpYTolerance
    }
}
