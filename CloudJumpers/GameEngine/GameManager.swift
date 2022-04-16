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
    var inChargeID: NetworkID?

    init(rendersTo scene: Scene?, inChargeID: NetworkID?, handlers: RemoteEventHandlers, rules: GameRules) {
        world = GameWorld(rendersTo: scene, subscribesTo: handlers)
        metaData = GameMetaData()
        self.inChargeID = inChargeID
        self.rules = rules
        self.rules.setTarget(world)
    }

    func update(within time: CGFloat) {
        world.update(within: time)
        rules.update(within: time)
        checkHasGameEnd()
    }

    func setUpGame(with blueprint: Blueprint, playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo]) {
        setUpEnvironment(with: blueprint)
        rules.setUpForRule()
        rules.setUpPlayers(playerInfo, allPlayersInfo: allPlayersInfo)
    }

    private func setUpEnvironment(with blueprint: Blueprint) {
        let cloudPositions = LevelGenerator.from(blueprint, seed: blueprint.seed)
        guard let highestPosition = cloudPositions.max(by: { $0.y < $1.y }) else {
            return
        }

        addPlatform(at: highestPosition)

        let wallHeight = (Constants.screenHeight / 2) + highestPosition.y + Constants.wallHeightFromPlatform
        addWall(at: Constants.leftWallPosition, height: wallHeight)
        addWall(at: Constants.rightWallPosition, height: wallHeight)
        addFloor(at: Constants.floorPosition)

        // TODO: Extend LevelGenerator so that this condition need not happen
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
        world.add(JoystickUpdateEvent(displacement: displacement))
    }

    func inputJump() {
        world.add(JumpButtonPressedEvent())
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
