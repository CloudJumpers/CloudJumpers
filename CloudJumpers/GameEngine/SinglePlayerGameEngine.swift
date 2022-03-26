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

    required init(for delegate: GameEngineDelegate) {
        entityManager = EntityManager()
        eventManager = EventManager()
        contactResolver = ContactResolver(to: eventManager,
                                          entityManager: entityManager)
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
            PowerUp(at: CGPoint(x: 200, y: -300), type: .freeze),
            PowerUp(at: CGPoint(x: -200, y: -300), type: .confuse),
            PowerUp(at: CGPoint(x: 0, y: -200), type: .confuse),
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
    }

    private func addNodeToScene(_ entity: Entity, with method: ((GameEngine, SKNode) -> Void)?) {
        guard let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity) else {
            return
        }

        method?(self, spriteComponent.node)
    }

    private func updateEvents() {
        eventManager.executeAll(in: entityManager)
    }

    private func handleGameEnd() {
        guard let timer = timer,
              let timedComponent = entityManager.component(ofType: TimedComponent.self, of: timer)
        else { return }

        let time = timedComponent.time
        let endGameState = TimeTrialGameEndState(playerEndTime: time)
        delegate?.engine(self, didEndGameWith: endGameState)
    }
}

// MARK: - InputResponder
extension SinglePlayerGameEngine: InputResponder {
    func inputMove(by displacement: CGVector) {
        guard let entity = associatedEntity else {
            return
        }

        eventManager.add(MoveEvent(on: entity, by: displacement))
    }

    func inputJump() {
        guard let entity = associatedEntity else {
            return
        }

        eventManager.add(JumpEvent(on: entity))
    }
}
