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
    let contactResolver: ContactResolver
    weak var delegate: GameEngineDelegate?
    var systems: [System]
    var associatedEntity: Entity?
    var metaData: GameMetaData

    required init(for delegate: GameEngineDelegate) {
        metaData = GameMetaData()
        entityManager = EntityManager()
        eventManager = EventManager()
        contactResolver = ContactResolver(to: eventManager)
        systems = []
        self.delegate = delegate
        setUpSystems()
    }

    func update(within time: CGFloat) {
        updateEvents()
        updateTime()
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
        let topPlatform = Platform(at: CGPoint(x: 0, y: 700))
        let entities: [Entity] = [
            Cloud(at: CGPoint(x: 200, y: -200)),
            Cloud(at: CGPoint(x: -100, y: -50)),
            Cloud(at: CGPoint(x: 200, y: 100)),
            Cloud(at: CGPoint(x: -100, y: 250)),
            Cloud(at: CGPoint(x: 200, y: 400)),
            Cloud(at: CGPoint(x: -100, y: 550))]

        entityManager.add(timer)
        entityManager.add(player)
        entityManager.add(topPlatform)
        entities.forEach(entityManager.add(_:))

        addNodeToScene(timer, with: delegate?.engine(_:addControlWith:))
        addNodeToScene(player, with: delegate?.engine(_:addPlayerWith:))
        entities.forEach { addNodeToScene($0, with: delegate?.engine(_:addEntityWith:)) }

        self.timer = timer
        associatedEntity = player
        metaData.playerId = player.id
        metaData.topPlatformId = topPlatform.id
    }

    private func addNodeToScene(_ entity: Entity, with method: ((GameEngine, SKNode) -> Void)?) {
        guard let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity) else {
            return
        }

        method?(self, spriteComponent.node)
    }

    private func updateEvents() {
        for event in eventManager.getEvents() {
            switch event.type {
            default:
                return
            }
        }

        eventManager.resetEventQueue()
    }

    // MARK: Temporary time update method
    private func updateTime() {
        guard let timer = timer,
              let timedComponent = entityManager.component(ofType: TimedComponent.self, of: timer)
        else { return }

        metaData.time = timedComponent.time
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
