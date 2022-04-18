//
//  RaceTopGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/30/22.
//

import Foundation
import CoreGraphics

class RaceTopGameRules: GameRules {

    private unowned var target: RuleModifiable?

    private var timer: StaticLabel?

    func setTarget(_ target: RuleModifiable) {
        self.target = target
    }

    var playerInfo: PlayerInfo?

    func setUpForRule() {
        guard let target = target else {
            return
        }
        self.timer = setUpTimer(initialValue: Constants.timerInitial, to: target)
        enablePowerUpFunction(target: target)
    }

    func setUpPlayers(_ playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo]) {
        self.playerInfo = playerInfo

        for (index, info) in allPlayersInfo.enumerated() {
            let id = info.playerId
            let name = info.displayName
            let character: Entity

            if id == playerInfo.playerId {
                character = Player(
                    at: Constants.playerInitialPositions[index],
                    texture: .Character1,
                    name: name,
                    with: id)
            } else {
                character = Guest(
                    at: Constants.playerInitialPositions[index],
                    texture: .Character1,
                    name: name,
                    with: id)
            }
            target?.add(character)
        }
    }
    func enableHostSystems() {
        target?.activateSystem(ofType: DisasterSpawnSystem.self)
        target?.activateSystem(ofType: PowerSpawnSystem.self)
    }

    func update(within time: CGFloat) {
        guard let target = target,
              let timer = timer
        else {
            return
        }

        updateRespawnIfPlayerOnSameCloudRule(target: target)
        updateCountUpTimer(target: target, timer: timer)
    }

    func hasGameEnd() -> Bool {
        guard let target = target else {
            return false
        }
        return isPlayerOnTopPlatform(target: target)
    }

    func fetchLocalCompletionData() -> LocalCompletionData {
        guard let timer = timer,
              let timedComponent = target?.component(ofType: TimedComponent.self, of: timer),
              let metricsProvider = target as? MetricsProvider,
              let playerInfo = playerInfo
        else { fatalError("Cannot get game data") }
        let metrics = metricsProvider.getMetricsSnapshot()

        return RaceToTopData(
            playerId: playerInfo.playerId,
            playerName: playerInfo.displayName,
            completionTime: timedComponent.time,
            kills: metrics[String(describing: ExternalRespawnEvent.self)] ?? 0,
            deaths: metrics[String(describing: RespawnEvent.self)] ?? 0
        )
    }
}
