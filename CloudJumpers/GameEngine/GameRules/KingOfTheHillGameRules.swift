//
//  KingOfTheHillGameRules.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 12/4/22.
//

import Foundation

class KingOfTheHillGameRules: GameRules {
    var isSpawningPowerUp = true

    var isSpawningDisaster = true

//    func createGameEvents(with gameData: GameMetaData) -> (localEvents: [Event], remoteEvents: [RemoteEvent]) {
//        // TODO: generate ScoreEvents
//    }

    func hasGameEnd(with gameData: GameMetaData) -> Bool {
        gameData.time >= GameModeConstants.kothDurationSeconds
    }
}
