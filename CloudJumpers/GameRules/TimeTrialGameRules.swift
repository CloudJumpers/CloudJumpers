//
//  TimeTrialGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation
class TimeTrialGameRules: GameRules {
    var isSpawningPowerUp = false

    var isSpawningDisaster = false

    func hasGameEnd(with gameData: GameMetaData) -> Bool {
        guard let playerLocationId = gameData.locationMapping[gameData.playerId]?.location else {
            return false
        }
        return playerLocationId == gameData.topPlatformId
    }

}
