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
    private var rules: GameRules
    private var achievementProcessor: AchievementProcessor

    private(set) var isHost = false

    init(
        rendersTo scene: Scene?,
        handlers: RemoteEventHandlers,
        rules: GameRules,
        achievementProcessor: AchievementProcessor
    ) {
        world = GameWorld(rendersTo: scene, subscribesTo: handlers)
        self.rules = rules
        self.achievementProcessor = achievementProcessor
        self.rules.setTarget(world)
        self.achievementProcessor.setTarget(world)
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
            delegate?.manager(self, didEndGameWith: rules.fetchLocalCompletionData())
        }
    }

}

// MARK: - InputResponder
extension GameManager: InputResponder {
    func inputMove(by displacement: CGVector) {
        world.add(JoystickUpdateEvent(displacement: displacement))
    }

    func inputJump() {
        world.add(JumpButtonPressedEvent())
    }

    func activatePowerUp(at location: CGPoint) {
        world.add(PowerUpLocationPressedEvent(location: location))
    }
}
