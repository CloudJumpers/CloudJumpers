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

    private var crossDeviceSyncTimer: Timer?

    required init(for delegate: GameEngineDelegate, channel: NetworkID? = nil) {
        metaData = GameMetaData()
        entityManager = EntityManager()
        eventManager = EventManager(channel: channel)
        contactResolver = ContactResolver(to: eventManager)
        systems = []
        self.delegate = delegate
        contactResolver.metaDataDelegate = self
        setUpCrossDeviceSyncTimer()
    }

    deinit {
        crossDeviceSyncTimer?.invalidate()
    }

    func update(within time: CGFloat) {
        updateEvents()
        updateTime()
        updateSystems(within: time)

        activateRandomDisaster()
    }

    func setUpGame() {
        setUpSampleGame()
        setUpSystems()
    }

    private func setUpCrossDeviceSyncTimer() {
        crossDeviceSyncTimer = Timer.scheduledTimer(
            withTimeInterval: GameConstants.positionalUpdateIntervalSeconds,
            repeats: true
        ) { [weak self] _ in self?.syncToOtherDevices() }
    }

    private func setUpSystems() {
        let timedSystem = TimedSystem(for: entityManager)
        let spriteSystem = SpriteSystem(for: entityManager)
        spriteSystem.delegate = delegate
        spriteSystem.associatedEntity = associatedEntity

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
        let leftWall = Wall(at: CGPoint(x: -350, y: 76.7))
        let rightWall = Wall(at: CGPoint(x: 350, y: 76.7))
        let floor = Floor(at: CGPoint(x: 0, y: -500))

        let entities: [Entity] = [
            Platform(at: CGPoint(x: 0, y: 1_000)),
            PowerUp(at: CGPoint(x: 200, y: -300), type: .freeze),
            PowerUp(at: CGPoint(x: -200, y: -300), type: .confuse),
            PowerUp(at: CGPoint(x: 0, y: -200), type: .confuse),
            Cloud(at: CGPoint(x: 200, y: -200)),
            Cloud(at: CGPoint(x: -200, y: 0)),
            Cloud(at: CGPoint(x: 200, y: 200)),
            Cloud(at: CGPoint(x: -200, y: 400)),
            Cloud(at: CGPoint(x: 200, y: 600)),
            Cloud(at: CGPoint(x: -200, y: 800))
        ]

        entityManager.add(timer)
        entityManager.add(player)
        entityManager.add(topPlatform)
        entityManager.add(leftWall)
        entityManager.add(rightWall)
        entityManager.add(floor)
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

    private func activateRandomDisaster() {
        // 1% chance that meteor will fall every 1/fps seconds
        guard getRandomEventHappen(at: 1), let entity = associatedEntity else {
            return
        }

        let disaster = Disaster(for: entity)
        entityManager.add(disaster)
    }

    private func getRandomEventHappen(at percentage: Int) -> Bool {
        Int.random(in: 1...100) <= percentage
    }
}

// MARK: - GameMetaDataDelegate
extension SinglePlayerGameEngine: GameMetaDataDelegate {
    func updatePlayerPosition(position: CGPoint) {
        metaData.playerPosition = position
    }

    func updatePlayerTextureKind(texture: Textures.Kind) {
        metaData.playerTexture = texture
    }

    func metaData(changePlayerLocation player: EntityID, location: EntityID?) {
        if let location = location {
            metaData.playerLocationMapping[player] = location
        } else {
            metaData.playerLocationMapping.removeValue(forKey: player)
        }
    }

    func syncToOtherDevices() {
        let positionalUpdate = OnlineRepositionEvent(
            positionX: metaData.playerPosition.x,
            positionY: metaData.playerPosition.y,
            texture: metaData.playerTexture.rawValue
        )

        let repositionCmd = RepositionEventCommand(sourceId: metaData.playerId, event: positionalUpdate)
        eventManager.dispatchGameEventCommand(repositionCmd)
    }
}

// MARK: - InputResponder
extension SinglePlayerGameEngine: InputResponder {
    func inputMove(by displacement: CGVector) {
        guard let entity = associatedEntity else {
            return
        }

        var event = MoveEvent(on: entity, by: displacement)
        event.gameDataTracker = self
        eventManager.add(event)
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
