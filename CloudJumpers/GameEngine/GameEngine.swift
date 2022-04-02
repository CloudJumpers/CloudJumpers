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
    var systems: [System]
    var metaData: GameMetaData
    var inChargeID: NetworkID?

    private var crossDeviceSyncTimer: Timer?

    required init(rendersTo spriteSystemDelegate: SpriteSystemDelegate,
                  inChargeID: NetworkID?, channel: NetworkID? = nil) {
        metaData = GameMetaData()
        entityManager = EntityManager()
        eventManager = EventManager(channel: channel)
        contactResolver = ContactResolver(to: eventManager)
        systems = []
        self.inChargeID = inChargeID
        contactResolver.metaDataDelegate = self
        setUpSystems(rendersTo: spriteSystemDelegate)
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

    func setUpGame(cloudBlueprint: Blueprint, powerUpBlueprint: Blueprint, playerId: EntityID,
                   additionalPlayerIds: [EntityID]?) {
        let cloudPositions = LevelGenerator.from(cloudBlueprint, seed: cloudBlueprint.seed)
        let powerUpPositions = LevelGenerator.from(powerUpBlueprint, seed: powerUpBlueprint.seed)
        setUpEnvironment(cloudPositions: cloudPositions, powerUpPositions: powerUpPositions)
        setUpPlayers(playerId, additionalPlayerIds: additionalPlayerIds ?? [])
        setUpSampleGame()
    }

    private func setUpEnvironment(cloudPositions: [CGPoint], powerUpPositions: [CGPoint]) {
        guard let highestPosition = cloudPositions.max(by: { $0.y < $1.y }) else {
            return
        }
        let topPlatform = Platform(at: highestPosition)

        let wallHeight = (Constants.screenHeight / 2) + highestPosition.y + Constants.wallHeightFromPlatform

        let leftWall = Wall(at: Constants.leftWallPosition, height: wallHeight)
        let rightWall = Wall(at: Constants.rightWallPosition, height: wallHeight)
        let floor = Floor(at: Constants.floorPosition)
        entityManager.add(topPlatform)
        entityManager.add(leftWall)
        entityManager.add(rightWall)
        entityManager.add(floor)
        metaData.topPlatformId = topPlatform.id
        metaData.highestPosition = highestPosition

        cloudPositions.forEach { position in
            if position != highestPosition {
                let newCloud = Cloud(at: position)
                entityManager.add(newCloud)
            }
        }

        powerUpPositions.forEach { position in
            guard let newPowerUp = generatePowerUp(at: position) else {
                return
            }

            entityManager.add(newPowerUp)
        }
    }

    private func setUpPlayers(_ playerId: EntityID, additionalPlayerIds: [EntityID]) {
        metaData.playerId = playerId
        var allPlayerId = [playerId] + additionalPlayerIds

        allPlayerId.sort()

        for (index, id) in allPlayerId.enumerated() {
            let character = Player(
                at: Constants.playerInitialPositions[index],
                texture: .character1,
                with: id,
                isCameraAnchor: id == playerId,
                isGuest: id != playerId)

            entityManager.add(character)

            if id == playerId {
                metaData.playerStartingPosition = Constants.playerInitialPositions[index]
            }
        }

    }

    private func setUpCrossDeviceSyncTimer() {
        crossDeviceSyncTimer = Timer.scheduledTimer(
            withTimeInterval: GameConstants.positionalUpdateIntervalSeconds,
            repeats: true
        ) { [weak self] _ in self?.syncToOtherDevices() }
    }

    private func setUpSystems(rendersTo spriteSystemDelegate: SpriteSystemDelegate) {
        let spriteSystem = SpriteSystem(for: entityManager)
        spriteSystem.delegate = spriteSystemDelegate
        spriteSystem.metaData = metaData
        systems.append(spriteSystem)
        systems.append(TimedSystem(for: entityManager))
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

        entityManager.add(timer)
        self.timer = timer
    }

    private func updateEvents() {
        if let inChargeID = inChargeID, metaData.playerId == inChargeID {
            eventManager.add(GenerateDisasterEvent(within: metaData.highestPosition.y))
        }
        eventManager.executeAll(in: entityManager)
    }

    // MARK: Temporary time update method
    private func updateTime() {
        guard let timer = timer,
              let timedComponent = entityManager.component(ofType: TimedComponent.self, of: timer)
        else { return }

        metaData.time = timedComponent.time
    }

    private func generatePowerUp(at position: CGPoint) -> PowerUp? {
        guard let powerUpType = PowerUpComponent.Kind.allCases.randomElement() else {
            return nil
        }
        return PowerUp(powerUpType, at: position)
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
            metaData.locationMapping[player] = (location, metaData.time)
        } else {
            metaData.locationMapping.removeValue(forKey: player)
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
        guard let entity = associatedEntity,
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity)
        else {
            return
        }

        eventManager.add(MoveEvent(on: entity, by: displacement))

        if physicsComponent.body.velocity == .zero {
            eventManager.add(AnimateEvent(on: entity, to: .walking))
        }
    }

    func inputJump() {
        guard let entity = associatedEntity else {
            return
        }

        eventManager.add(JumpEvent(on: entity))
        eventManager.add(AnimateEvent(on: entity, to: .jumping))
    }

    func activatePowerUp(at location: CGPoint) {
        guard let entity = associatedEntity else {
            return
        }

        eventManager.add(ActivatePowerUpEvent(in: entity, location: location))
    }
}
