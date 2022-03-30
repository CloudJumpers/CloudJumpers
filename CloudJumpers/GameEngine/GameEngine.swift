//
//  GameEngine.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 24/3/22.
//

import SpriteKit

class GameEngine {
    let entityManager: EntityManager
    let eventManager: EventManager
    let contactResolver: ContactResolver
    weak var delegate: GameEngineDelegate?
    var systems: [System]
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
    }

    func updatePlayer(with displacement: CGVector) {
        guard let entity = associatedEntity,
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity),
              let animationComponent = entityManager.component(ofType: AnimationComponent.self, of: entity),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else {
            return
        }
        if displacement != .zero {
            inputMove(by: displacement)
        } else if physicsComponent.body.velocity == .zero {
            eventManager.add( AnimateEvent(on: entity, to: .idle))
        }

        updatePlayerTextureKind(texture: animationComponent.kind)
        updatePlayerPosition(position: spriteComponent.node.position)
    }

    func setUpGame(with clouds: [Cloud], powerUps: [PowerUp], playerId: EntityID, additionalPlayerIds: [EntityID]?) {
        setUpClouds(clouds)
        setUpPowerUps(powerUps)
        setUpSampleGame(playerId, additionalPlayerIds: additionalPlayerIds ?? [])
        setUpSystems()
    }

    private func setUpClouds(_ clouds: [Cloud]) {
        clouds.forEach { entity in
            entityManager.add(entity)
        }
    }

    private func setUpPowerUps(_ powerUps: [PowerUp]) {
        powerUps.forEach { entity in
            entityManager.add(entity)
        }
        entityManager.add(PowerUp(at: CGPoint(x: -200.0, y: -300.0), type: .freeze))
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

    private func setUpSampleGame(_ playerId: EntityID, additionalPlayerIds: [EntityID]) {
        let timer = TimedLabel(at: Constants.timerPosition, initial: Constants.timerInitial)
        let player = Player(at: Constants.playerInitialPosition, texture: .character1, with: playerId)
        let topPlatform = Platform(at: CGPoint(x: 0, y: 700))
        let leftWall = Wall(at: CGPoint(x: -350, y: 76.7))
        let rightWall = Wall(at: CGPoint(x: 350, y: 76.7))
        let floor = Floor(at: CGPoint(x: 0, y: -500))

        entityManager.add(timer)
        entityManager.add(player)
        entityManager.add(topPlatform)
        entityManager.add(leftWall)
        entityManager.add(rightWall)
        entityManager.add(floor)

        let otherPlayers = additionalPlayerIds.map {
            Player(at: Constants.playerInitialPosition, texture: .character1, with: $0)
        }
        otherPlayers.forEach(entityManager.add(_:))

        self.timer = timer
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
extension GameEngine: GameMetaDataDelegate {
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
extension GameEngine: InputResponder {
    var associatedEntity: Entity? {
        get {
            entityManager.entity(with: metaData.playerId)
        }
        set {
            if let newId = newValue?.id {
                metaData.playerId = newId
            }
        }
    }

    func inputMove(by displacement: CGVector) {
        guard let entity = associatedEntity else {
            return
        }
        eventManager.add(MoveEvent(on: entity, by: displacement))
        eventManager.add(AnimateEvent(on: entity, to: .walking))

    }

    func inputJump() {
        guard let entity = associatedEntity else {
            return
        }

        eventManager.add(JumpEvent(on: entity))
        eventManager.add(AnimateEvent(on: entity, to: .jumping))
    }

    func activatePowerUp(touchLocation: CGPoint) {
        guard let entity = associatedEntity else {
            return
        }

        eventManager.add(ActivatePowerUpEvent(on: entity, location: touchLocation))
    }
}
