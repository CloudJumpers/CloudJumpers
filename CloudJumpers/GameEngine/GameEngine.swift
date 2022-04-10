//
//  GameEngine.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 24/3/22.
//

import SpriteKit

class GameEngine {
    let entityManager: EntityManager
    var metaData: GameMetaData
    var inChargeID: NetworkID?
    let rules: GameRules

    var hasGameEnd: Bool {
        rules.hasGameEnd(with: metaData)
    }

    private var crossDeviceSyncTimer: Timer?

    required init(rendersTo spriteSystemDelegate: SpriteSystemDelegate,
                  rules: GameRules,
                  inChargeID: NetworkID?, channel: NetworkID? = nil ) {
        metaData = GameMetaData()
        entityManager = EntityManager()
        setUpEventDispatcher(entityManager, on: channel)

        self.rules = rules
        self.inChargeID = inChargeID
        setUpCrossDeviceSyncTimer()
    }

    deinit {
        crossDeviceSyncTimer?.invalidate()
    }

    func update(within time: CGFloat) {
        updateEntityManager(within: time)
        updateTime()
    }

    func setUpEventDispatcher(_ eventDispatcher: EventDispatcher, on channel: NetworkID?) {
        guard let channel = channel else {
            return
        }

        eventDispatcher.subscriber = FirebaseSubscriber(channel)
        eventDispatcher.publisher = FirebasePublisher(channel)
    }

    func updateEntityManager(within time: CGFloat) {
        entityManager.update(within: time)
    }

    // TODO: This shouldn't touch PhysicsComponent anymore
    func updatePlayer(with displacement: CGVector) {
        guard let entity = associatedEntity,
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity)
        else {
            return
        }
        if displacement != .zero {
            inputMove(by: displacement)
        } else if physicsComponent.body.velocity == .zero {
            eventManager.add( AnimateEvent(on: entity, to: .idle))
        }
    }

    func setUpGame(cloudBlueprint: Blueprint, powerUpBlueprint: Blueprint,
                   playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo]) {
        let cloudPositions = LevelGenerator.from(cloudBlueprint, seed: cloudBlueprint.seed)
        setUpEnvironment(cloudPositions: cloudPositions)
        setUpPlayers(playerInfo, allPlayersInfo: allPlayersInfo)
        setUpSampleGame()

        if rules.isSpawningPowerUp {
            generatePowerUp(blueprint: powerUpBlueprint)
        }
    }

    private func setUpEnvironment(cloudPositions: [CGPoint]) {
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

    }

    private func setUpPlayers(_ playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo]) {
        metaData.playerId = playerInfo.playerId

        for (index, info) in allPlayersInfo.enumerated() {
            let id = info.playerId
            let name = info.displayName
            let character: Entity

            if id == playerInfo.playerId {
                character = Player(
                    at: Constants.playerInitialPositions[index],
                    texture: .character1,
                    name: name,
                    with: id)
                metaData.playerStartingPosition = Constants.playerInitialPositions[index]
            } else {
                character = Guest(
                    at: Constants.playerInitialPositions[index],
                    texture: .character1,
                    name: name,
                    with: id)
            }
            entityManager.add(character)
        }

    }
    
    // TODO: Bring this into PlayerStateSynchronizer
    private func setUpCrossDeviceSyncTimer() {
        crossDeviceSyncTimer = Timer.scheduledTimer(
            withTimeInterval: GameConstants.positionalUpdateIntervalSeconds,
            repeats: true
        ) { [weak self] _ in self?.syncToOtherDevices() }
    }


    // MARK: - Temporary methods to abstract
    private var timer: TimedLabel?

    private func setUpSampleGame() {
        let timer = TimedLabel(at: Constants.timerPosition, initial: Constants.timerInitial)
        entityManager.add(timer)
        self.timer = timer
    }

    // TODO: This shouldn't happen here anymore
    private func updateEvents() {
        // TODO: Abstract this further if possible - @jusg
        let rulesEvents = rules.createGameEvents(with: metaData)
        rulesEvents.localEvents.forEach { eventManager.add($0) }
        rulesEvents.remoteEvents.forEach { eventManager.publish($0) }
        eventManager.executeAll(in: entityManager)
    }

    // TODO: Refactor this with dynamic power up spawn- @jushg
    private func generatePowerUp(blueprint: Blueprint) {
        let powerUpPositions = LevelGenerator.from(blueprint, seed: blueprint.seed)

        for (index, position) in powerUpPositions.enumerated() {
            guard let newPowerUp = generatePowerUp(at: position,
                                                   type: index,
                                                   id: generatePowerUpId(idx: index, position: position))
           else { return }

            entityManager.add(newPowerUp)
        }

    }

    // MARK: Temporary time update method
    private func updateTime() {
        guard let timer = timer,
              let timedComponent = entityManager.component(ofType: TimedComponent.self, of: timer)
        else { return }

        metaData.time = timedComponent.time
    }

    private func generatePowerUp(at position: CGPoint, type: Int, id: String) -> PowerUp? {
        let powerUpTypeCount = PowerUpComponent.Kind.allCases.count
        let powerUpType = PowerUpComponent.Kind.allCases[type % powerUpTypeCount]
        return PowerUp(powerUpType, at: position, with: id)
    }

    private func generatePowerUpId(idx: Int, position: CGPoint) -> String {
        "powerUp\(idx)\(position.x)\(position.y)"
    }
}

// MARK: - GameMetaDataDelegate
extension GameEngine: GameMetaDataDelegate {
    func metaData(changePlayerLocation player: EntityID, location: EntityID?) {
        if let location = location {
            metaData.locationMapping[player] = (location, metaData.time)
        } else {
            metaData.locationMapping.removeValue(forKey: player)
        }
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

        let playerMoveEvent = MoveEvent(on: entity, by: displacement)
            .then(do: SoundEvent(onEntityWith: entity.id, soundName: .walking))

        eventManager.add(playerMoveEvent)

        if physicsComponent.body.velocity == .zero {
            eventManager.add(AnimateEvent(on: entity, to: .walking))
        }
    }

    func inputJump() {
        guard let entity = associatedEntity else {
            return
        }
        let playerJumpEvent = JumpEvent(on: entity)
            .then(do: SoundEvent(onEntityWith: entity.id, soundName: .jumpCape))
            .then(do: SoundEvent(onEntityWith: entity.id, soundName: .jumpFoot))

        eventManager.add(playerJumpEvent)
        eventManager.add(AnimateEvent(on: entity, to: .jumping))
    }

    func activatePowerUp(at location: CGPoint) {
        guard let entity = associatedEntity else {
            return
        }

        eventManager.add(ActivatePowerUpEvent(in: entity, location: location))
    }
}
