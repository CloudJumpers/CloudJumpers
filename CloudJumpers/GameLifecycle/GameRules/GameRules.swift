//
//  GameModes.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation
import CoreGraphics

protocol GameRules {

    var player: Entity? { get }
    func setTarget(_ target: RuleModifiable)
    func setUpForRule()
    func setUpPlayers(_ playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo])
    func update(within time: CGFloat)
    func hasGameEnd() -> Bool

    func fetchLocalCompletionData()

}

// MARK: Helper functions
extension GameRules {
    func isPlayerRespawn(target: RuleModifiable) -> Bool {
        guard let player = player,
              let playerStandOnComponent = target.component(ofType: StandOnComponent.self, of: player)
        else {
            return false
        }
        let allStandOnComponent = target.components(ofType: StandOnComponent.self)

        for component in allStandOnComponent where component.entity?.id != player.id {
            if component.standOnEntityID == playerStandOnComponent.standOnEntityID &&
                component.timestamp > playerStandOnComponent.timestamp {
                return true
            }
        }
        return false
    }

    func updateLabelWithValue(_ value: String, label: StaticLabel, target: RuleModifiable) {
        guard let labelComponent = target.component(ofType: LabelComponent.self, of: label) else {
            return
        }
        labelComponent.displayValue = value
    }
}
