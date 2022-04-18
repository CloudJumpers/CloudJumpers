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
        target.deactivateSystem(ofType: PowerSpawnSystem.self)
        self.timer = setUpTimer(initialValue: Constants.timerInitial, to: target)

    }

    func setUpPlayers(_ playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo]) {
        self.playerInfo = playerInfo
        for (index, info) in allPlayersInfo.enumerated() {
            let id = info.playerId
            let name = info.displayName

            if id == playerInfo.playerId {
                target?.add(Player(
                    at: Constants.playerInitialPositions[index],
                    texture: .Character1,
                    name: name,
                    with: id))
            } else if id == GameConstants.shadowPlayerID {
                target?.add(ShadowGuest(
                    at: Constants.playerInitialPositions[index],
                    texture: .ShadowCharacter1,
                    name: name,
                    with: id))
            }
        }
    }

    func enableHostSystems() {
    }

    func update(within time: CGFloat) {
        guard let target = target,
              let timer = timer,
              let timedComponent = target.component(ofType: TimedComponent.self, of: timer)
        else {
            return
        }
        let timeString = timedComponent.time.convertToTimeString()

        updateLabelWithValue(timeString, label: timer, target: target)
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
