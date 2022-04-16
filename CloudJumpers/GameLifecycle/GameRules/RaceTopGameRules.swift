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
        guard let playerID = playerInfo?.playerId,
              let target = target,
              let timer = timer,
              let timedComponent = target.component(ofType: TimedComponent.self, of: timer)
        else {
            return
        }
        if isPlayerRespawning(target: target) {
            target.add(RespawnEvent(onEntityWith: playerID, newPosition: Constants.playerInitialPosition))
            target.dispatch(ExternalRespawnEvent(
                positionX: Constants.playerInitialPosition.x,
                positionY: Constants.playerInitialPosition.y))
            target.add(ChangeStandOnLocationEvent(on: playerID, standOnEntityID: nil))
        }

        updateLabelWithValue(String(timedComponent.time), label: timer, target: target)
    }

    func hasGameEnd() -> Bool {
        guard let target = target,
              let playerID = playerInfo?.playerId,
              let stoodOnEntityID = target.component(ofType: StandOnComponent.self, of: playerID)?.standOnEntityID
        else {
            return false
        }
        return target.hasComponent(ofType: TopPlatformTag.self, in: stoodOnEntityID)
    }

    func fetchLocalCompletionData() -> LocalCompletionData {
        guard let timer = timer,
              let timedComponent = target?.component(ofType: TimedComponent.self, of: timer),
              let playerInfo = playerInfo
        else { fatalError("Cannot get timer data") }
        return RaceToTopData(
            playerId: playerInfo.playerId,
            playerName: playerInfo.displayName,
            completionTime: timedComponent.time)
    }

}
