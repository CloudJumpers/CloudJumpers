//
//  GameModes.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation
import CoreGraphics

protocol GameRules {
    func setTarget(_ target: RuleModifiable)
    func setUpForRule()
    func setUpPlayers(_ playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo])
    func update()
    func hasGameEnd() -> Bool

    func fetchLocalCompletionData()

    func createRuleSpecificEntity() -> [Entity]
}
extension GameRules {
    func update() { }
}
