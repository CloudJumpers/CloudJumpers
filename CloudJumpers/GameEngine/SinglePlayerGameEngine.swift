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

    required init(for delegate: GameEngineDelegate, channel: NetworkID? = nil) {
        metaData = GameMetaData()
        entityManager = EntityManager()
        eventManager = EventManager(channel: channel)
        contactResolver = ContactResolver(to: eventManager)
        systems = []
        self.delegate = delegate
        contactResolver.metaDataDelegate = self
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
        let timedSystem = TimedSystem(for: entityManager)
        let spriteSystem = SpriteSystem(for: entityManager)
        spriteSystem.delegate = delegate

        systems.append(timedSystem)
        systems.append(spriteSystem)
    }

    private func updateSystems(within time: CGFloat) {
        for system in systems {
            system.update(within: time)
        }
    }

    // MARK: - Temporary methods to abstract
    private var timer: TimedLabel?

    private func setUpSampleGame() {
        guard let userId = AuthService().getUserId() else {
            return
        }

        let timer = TimedLabel(at: Constants.timerPosition, initial: Constants.timerInitial)
        let player = Player(at: Constants.playerInitialPosition, texture: .character1, with: userId)
        let topPlatform = Platform(at: CGPoint(x: 0, y: 700))
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
        entityManager.add(topPlatform)
        entities.forEach(entityManager.add(_:))

        self.timer = timer
        associatedEntity = player
        metaData.playerId = player.id
        metaData.topPlatformId = topPlatform.id
    }

    private func updateEvents() {
        eventManager.executeAll(in: entityManager)
    }

    // MARK: Temporary time update method
    private func updateTime() {
        guard let timer = timer,
              let timedComponent = entityManager.component(ofType: TimedComponent.self, of: timer)
        else { return }

        metaData.time = timedComponent.time
    }
}

// MARK: - GameMetaDataDelegate
extension SinglePlayerGameEngine: GameMetaDataDelegate {
    func metaData(changePlayerLocation player: EntityID, location: EntityID?) {
        if let location = location {
            metaData.playerLocationMapping[player] = location
        } else {
            metaData.playerLocationMapping.removeValue(forKey: player)
        }
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

    func activatePowerUp(touchLocation: CGPoint) {
        guard let entity = associatedEntity else {
            return
        }

        eventManager.add(ActivatePowerUpEvent(on: entity, location: touchLocation))
    }
}
