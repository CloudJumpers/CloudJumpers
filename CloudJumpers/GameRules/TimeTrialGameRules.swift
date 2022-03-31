//
//  TimeTrialGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation
class TimeTrialGameRules: GameRules {
    func prepareGameModes(gameEngine: GameEngine, blueprint: Blueprint) {
        guard let userId = AuthService().getUserId() else {
            fatalError("Cannot find user")
        }

        gameEngine.setUpGame(
            with: blueprint,
            playerId: userId,
            additionalPlayerIds: nil)
    }

    func createGameEvents(with gameData: GameMetaData) -> [Event] {
        []
    }

    func hasGameEnd(with gameData: GameMetaData) -> Bool {
        guard let playerLocationId = gameData.locationMapping[gameData.playerId]?.0 else {
            return false
        }
        return playerLocationId == gameData.topPlatformId
    }

}
