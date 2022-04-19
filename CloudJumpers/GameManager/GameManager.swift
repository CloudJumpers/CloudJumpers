//
//  GameEngine.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 24/3/22.
//

import UIKit
import RenderCore
import ContentGenerator

class GameManager {
    unowned var delegate: GameManagerDelegate?

    private var world: GameWorld
    private var rules: GameRules

    private var achievementUpdater: AchievementUpdateDelegate
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
        self.achievementUpdater = PollingUpdateDelegate()
        self.achievementProcessor.updater = achievementUpdater
        self.achievementUpdater.processor = achievementProcessor

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

    func setUpGame(
        size worldSize: CGSize,
        with blueprint: Blueprint,
        velocity: VelocityTemplate,
        playerInfo: PlayerInfo,
        allPlayersInfo: [PlayerInfo]
    ) {
        setUpEnvironment(size: worldSize, with: blueprint, velocity: velocity)
        rules.setUpForRule()
        rules.setUpPlayers(playerInfo, allPlayersInfo: allPlayersInfo)
    }

    private func setUpEnvironment(size worldSize: CGSize, with blueprint: Blueprint, velocity: VelocityTemplate) {
        let cloudPositions = LevelGenerator.positionsFrom(blueprint)
        guard let highestPosition = cloudPositions.max(by: { $0.y < $1.y }) else {
            return
        }

        let cloudVelocities = LevelGenerator.velocitiesFrom(velocity, size: cloudPositions.count)

        addPlatform(at: highestPosition)
        addWalls(upTo: highestPosition)
        addFloor(at: Positions.floor)

        for idx in 0..<cloudPositions.count where cloudPositions[idx] != highestPosition {
            world.add(Cloud(at: cloudPositions[idx], texture: .cloud1, horizontalVelocity: cloudVelocities[idx]))
        }

        world.add(Area(size: worldSize))
        world.add(HUD(at: Positions.hud))
    }

    private func addPlatform(at position: CGPoint) {
        world.add(Platform(at: position, texture: .platform))
    }

    private func addFloor(at position: CGPoint) {
        world.add(Floor(at: position, texture: .floor))
    }

    private func addWalls(upTo highestPosition: CGPoint) {
        let screenHeight = UIScreen.main.bounds.size.height
        let height = (screenHeight / 2) + highestPosition.y + Dimensions.wallHeightFromPlatform
        world.add(Wall(at: Positions.leftWall, height: height, texture: .wall))
        world.add(Wall(at: Positions.rightWall, height: height, texture: .wall))
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
