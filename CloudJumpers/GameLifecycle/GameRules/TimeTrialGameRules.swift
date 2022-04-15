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
    private var timer: TimedLabel?
    private var isPlayingWithShadow = true

    func setTarget(_ target: RuleModifiable) {
        self.target = target
    }

    func setUpForRule() {
        if isPlayingWithShadow {
            target?.deactivateSystem(ofType: DisasterSpawnSystem.self)
        }
        target?.deactivateSystem(ofType: PowerSpawnSystem.self)

        // Set game specific entity

        let timer = TimedLabel(at: Constants.timerPosition, initial: Constants.timerInitial)
        self.timer = timer
        target?.add(timer)
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
            } else if id == GameConstants.shadowPlayerID {
                character = ShadowGuest(
                    at: Constants.playerInitialPositions[index],
                    texture: .ShadowCharacter1,
                    name: name,
                    with: id)
            }
            target?.add(character)
        }
    }

    func update(within time: CGFloat) {
        // TODO: Update timer here
    }

    func hasGameEnd() -> Bool {
        guard let target = target,
              let player = target.components(ofType: PlayerTag.self).first?.entity,
              let stoodOnEntityID = target.component(ofType: StandOnComponent.self, of: player)?.standOnEntityID
        else {
            return false
        }
        return target.hasComponent(ofType: TopPlatformTag.self, in: stoodOnEntityID)
    }

    func fetchLocalCompletionData() {
        guard let timer = timer,
              let timedComponent = target?.component(ofType: TimedComponent.self, of: timer)
        else { return }

        // TODO: Return time for completion
    }
}
