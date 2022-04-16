//
//  GameEngine.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 24/3/22.
//

import SpriteKit

class GameManager {
    unowned var delegate: GameManagerDelegate?

    private var world: GameWorld
    private var metaData: GameMetaData
    private var rules: GameRules
    private(set) var isHost = false

    init(rendersTo scene: Scene?, handlers: RemoteEventHandlers, rules: GameRules) {
        world = GameWorld(rendersTo: scene, subscribesTo: handlers)
        metaData = GameMetaData()
        self.rules = rules
        self.rules.setTarget(world)
    }

    func update(within time: CGFloat) {
        world.update(within: time)
        rules.update(within: time)
        checkHasGameEnd()
    }

    func enableHostStatus() {
        self.isHost = true
        rules.enableHostSystems()
    }

    // TODO: This shouldn't touch PhysicsComponent anymore
    func updatePlayer(with displacement: CGVector) {
        guard let entity = associatedEntity else {
            return
        }

        if displacement != .zero {
            inputMove(by: displacement)
        } else {
            // TODO: Figure out how to do without WhenStationaryEvent
            let animateEvent = AnimateEvent(onEntityWith: entity.id, to: CharacterFrames.idle.key)
            world.add(WhenStationaryEvent(entity.id, do: animateEvent))
        }
    }

    func setUpGame(with blueprint: Blueprint, playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo]) {
        setUpEnvironment(with: blueprint)
        rules.setUpForRule()
        rules.setUpPlayers(playerInfo, allPlayersInfo: allPlayersInfo)
    }

    private func setUpEnvironment(with blueprint: Blueprint) {
        let cloudPositions = LevelGenerator.positionFrom(blueprint)
        guard let highestPosition = cloudPositions.max(by: { $0.y < $1.y }) else {
            return
        }

        addPlatform(at: highestPosition)

        let wallHeight = (Constants.screenHeight / 2) + highestPosition.y + Constants.wallHeightFromPlatform
        addWall(at: Constants.leftWallPosition, height: wallHeight)
        addWall(at: Constants.rightWallPosition, height: wallHeight)
        addFloor(at: Constants.floorPosition)

        // TODO: Extend LevelGenerator so that this condition need not happen
        // TODO: Add oscillation to Cloud, and possibly ExternalRepositionCloudEvent?
        for cloudPosition in cloudPositions where cloudPosition != highestPosition {
            world.add(Cloud(at: cloudPosition, texture: .cloud1))
        }
    }

    private func addPlatform(at position: CGPoint) {
        world.add(Platform(at: position, texture: .platform))
    }

    private func addFloor(at position: CGPoint) {
        world.add(Floor(at: position, texture: .floor))
    }

    private func addWall(at position: CGPoint, height: CGFloat) {
        world.add(Wall(at: position, height: height, texture: .wall))
    }

    private func checkHasGameEnd() {
        if rules.hasGameEnd() {
            delegate?.manager(self, didEndGameWith: metaData)
        }
    }

}

// MARK: - InputResponder
extension GameManager: InputResponder {
    var associatedEntity: Entity? {
        get { world.entity(with: metaData.playerId) }
        set { metaData.playerId = newValue?.id ?? EntityID() }
    }

    // TODO: This shouldn't touch Components
    func inputMove(by displacement: CGVector) {
        guard let entity = associatedEntity else {
            return
        }

        let moveEvent = MoveEvent(onEntityWith: entity.id, by: displacement)
        let soundEvent = SoundEvent(.walking)

        world.add(moveEvent.then(do: soundEvent))

        // TODO: Figure out how to do without WhenStationaryEvent
        let animateEvent = AnimateEvent(onEntityWith: entity.id, to: CharacterFrames.walking.key)
        world.add(WhenStationaryEvent(entity.id, do: animateEvent))
    }

    func inputJump() {
        guard let entity = associatedEntity else {
            return
        }

        let jumpEvent = JumpEvent(onEntityWith: entity.id)
        let soundEvent = SoundEvent(.jumpCape).then(do: SoundEvent(.jumpFoot))

        // TODO: Figure out how to integrate AnimateEvent into JumpEvent
        let animateEvent = AnimateEvent(onEntityWith: entity.id, to: CharacterFrames.jumping.key)

        world.add(jumpEvent.then(do: soundEvent))
        world.add(animateEvent)
    }

    func activatePowerUp(at location: CGPoint) {
        guard let entity = associatedEntity else {
            return
        }

        world.add(PowerUpActivateEvent(by: entity.id, location: location))

        world.dispatch(ExternalPowerUpActivateEvent(
            activatePowerUpPositionX: location.x,
            activatePowerUpPositionY: location.y))
    }
}
