//
//  TimeTrialGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation
class TimeTrialGameRules: GameRules {

    func hasGameEnd(with gameData: GameMetaData) -> Bool {
        guard let playerLocationId = gameData.playerLocationMapping[gameData.playerId] else {
            return false
        }
        return playerLocationId == gameData.topPlatformId
    }
}
