//
//  GameModes.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import UIKit

protocol GameRules {
    var playerInfo: PlayerInfo? { get set }
    func setTarget(_ target: RuleModifiable)
    func setUpForRule()
    func setUpPlayers(_ playerInfo: PlayerInfo, allPlayersInfo: [PlayerInfo])
    func enableHostSystems()
    func update(within time: CGFloat)
    func hasGameEnd() -> Bool
    func fetchLocalCompletionData() -> LocalCompletionData
}
