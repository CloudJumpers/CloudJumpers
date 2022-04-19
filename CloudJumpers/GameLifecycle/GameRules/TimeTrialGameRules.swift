//
//  TimeTrialGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation
import CoreGraphics

class TimeTrialGameRules: GameRules {
    private unowned var target: RuleModifiable?
    private var timer: StaticLabel?

    var playerInfo: PlayerInfo?

    func setTarget(_ target: RuleModifiable) {
        self.target = target
    }

    func setUpForRule() {
        guard let target = target else {
            return
        }
        self.timer = setUpTimer(initialValue: Constants.timerInitial, to: target)
    }

    func setUpPlayers(_ playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo]) {
        self.playerInfo = playerInfo
        for (index, info) in allPlayersInfo.enumerated() {
            let id = info.playerId
            let name = info.displayName

            if id == playerInfo.playerId {
                target?.add(Player(
                    at: Positions.players[index],
                    texture: .Character1,
                    name: name,
                    with: id))
            } else if id == GameConstants.shadowPlayerID {
                target?.add(ShadowGuest(
                    at: Positions.players[index],
                    texture: .ShadowCharacter1,
                    name: name,
                    with: id))
            }
        }
    }

    func enableHostSystems() {
        target?.activateSystem(ofType: DisasterSpawnSystem.self)
    }

    func update(within time: CGFloat) {
        guard let target = target,
              let timer = timer
        else {
            return
        }
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
              let playerInfo = playerInfo
        else { fatalError("Cannot get timer data") }
        return TimeTrialData(
            playerId: playerInfo.playerId,
            playerName: playerInfo.displayName,
            completionTime: timedComponent.time)
    }
}
