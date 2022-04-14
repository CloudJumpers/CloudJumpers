//
//  GameEngine.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 24/3/22.
//

import SpriteKit

class GameManager {
    private var world: GameWorld

    var metaData: GameMetaData
    var inChargeID: NetworkID?

    private var crossDeviceSyncTimer: Timer?

    init(rendersTo scene: Scene?, inChargeID: NetworkID?, handlers: RemoteEventHandlers) {
        world = GameWorld(rendersTo: scene, subscribesTo: handlers)

        metaData = GameMetaData()
        self.inChargeID = inChargeID
        setUpCrossDeviceSyncTimer()
    }

    deinit {
        crossDeviceSyncTimer?.invalidate()
    }

    func update(within time: CGFloat) {
        world.update(within: time)
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

    func setUpGame(cloudBlueprint: Blueprint) {
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
}

// MARK: - InputResponder
extension GameManager: InputResponder {
    var associatedEntity: Entity? {
        get { world.entity(with: metaData.playerId) }
        set { metaData.playerId = newValue?.id ?? EntityID() }
    }

    func inputMove(by displacement: CGVector) {
        guard let entity = associatedEntity,
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity)
        else { return }

        let moveEvent = MoveEvent(onEntityWith: entity.id, by: displacement)
        let soundEvent = SoundEvent(.walking)

        entityManager.add(moveEvent.then(do: soundEvent))

        // TODO: Figure out how to abstract this
        if physicsComponent.body.velocity == .zero {
            eventManager.add(AnimateEvent(on: entity, to: .walking))
        }
    }

    func inputJump() {
        guard let entity = associatedEntity else {
            return
        }

        let jumpEvent = JumpEvent(onEntityWith: entity.id)
        let soundEvent = SoundEvent(.jumpCape).then(do: SoundEvent(.jumpFoot))

        // TODO: Figure out how to integrate AnimateEvent into JumpEvent
        let animateEvent = AnimateEvent(onEntityWith: entity.id, to: .walking)

        entityManager.add(jumpEvent.then(do: soundEvent))
        entityManager.add(animateEvent)
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

extension GameManager: GameEngineUpdatable {
    func beginContact(between nodeA: Node, and nodeB: Node) {
        <#code#>
    }

    func endContact(between nodeA: Node, and nodeB: Node) {
        <#code#>
    }

    func node(from nodeCore: NodeCore) -> Node? {
        <#code#>
    }

    func updatePositions(to positions: [CGPoint]) {
        <#code#>
    }

    func updateVelocities(to velocities: [CGVector]) {
        <#code#>
    }
}
