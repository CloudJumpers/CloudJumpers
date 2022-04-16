//
//  KingHillGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/15/22.
//

import Foundation

import CoreGraphics

class KingHillGameRules: GameRules {
    private unowned var target: RuleModifiable?

    private var countDownTimer: StaticLabel?
    private var scoreLabel: StaticLabel?

    var playerInfo: PlayerInfo?

    func setTarget(_ target: RuleModifiable) {
        self.target = target
    }

    func setUpForRule() {
        guard let target = target else {
            return
        }

        // TODO: Create count down timer and score label

    }

    func setUpPlayers(_ playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo]) {
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
              let target = target
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

        // TODO: Add timer update here
    }

    // TODO: Change this
    func hasGameEnd() -> Bool {
        false
    }

    // TODO: Update score

    func fetchLocalCompletionData() -> LocalCompletionData {
        guard let playerInfo = playerInfo
        else { fatalError("Cannot get timer data") }

        return KingHillData(
            playerId: playerInfo.playerId,
            playerName: playerInfo.displayName,
            completionScore: .zero)
    }

}
