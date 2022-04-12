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

    private var crossDeviceSyncTimer: Timer?

    required init(rendersTo spriteSystemDelegate: SpriteSystemDelegate,
                  inChargeID: NetworkID?, handlers: RemoteEventHandlers) {
        metaData = GameMetaData()
        entityManager = EntityManager()
        setUpEventDispatcher(entityManager, handlers: handlers)

        self.inChargeID = inChargeID
        setUpCrossDeviceSyncTimer()
    }

    deinit {
        crossDeviceSyncTimer?.invalidate()
    }

    func update(within time: CGFloat) {
        updateEntityManager(within: time)
    }

    func setUpEventDispatcher(_ eventDispatcher: EventDispatcher, handlers: RemoteEventHandlers) {
        eventDispatcher.subscriber = handlers.subscriber
        eventDispatcher.publisher = handlers.publisher
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

    func setUpGame(cloudBlueprint: Blueprint, powerUpBlueprint: Blueprint) {
        let cloudPositions = LevelGenerator.from(cloudBlueprint, seed: cloudBlueprint.seed)
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

        cloudPositions.forEach { position in
            if position != highestPosition {
                let newCloud = Cloud(at: position)
                entityManager.add(newCloud)
            }
        }

    }
    // TODO: Bring this into PlayerStateSynchronizer
    private func setUpCrossDeviceSyncTimer() {
        crossDeviceSyncTimer = Timer.scheduledTimer(
            withTimeInterval: GameConstants.positionalUpdateIntervalSeconds,
            repeats: true
        ) { [weak self] _ in self?.syncToOtherDevices() }
    }

    private func syncToOtherDevices () {
        entityManager.system(ofType: PlayerStateSystem.self)?.uploadLocalPlayerState()
    }

    // TODO: This shouldn't happen here anymore
    private func updateEvents() {
        eventManager.executeAll(in: entityManager)
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

        entityManager.add(PowerUpActivateEvent(by: entity.id, location: location))

        entityManager.dispatch(ExternalPowerUpActivateEvent(
            activatePowerUpPositionX: location.x,
            activatePowerUpPositionY: location.y))
    }
}
