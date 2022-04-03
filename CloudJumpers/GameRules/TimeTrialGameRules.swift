//
//  TimeTrialGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation
class TimeTrialGameRules: GameRules {
    func createGameEvents(with gameData: GameMetaData) -> (localEvents: [Event], remoteEvents: [RemoteEvent]) {
        ([], [])
    }

    func prepareGameModes(gameEngine: GameEngine,
                          cloudBlueprint: Blueprint,
                          powerUpBlueprint: Blueprint) {
        guard let userId = AuthService().getUserId() else {
            fatalError("Cannot find user")
        }

        gameEngine.setUpGame(
            cloudBlueprint: cloudBlueprint,
            powerUpBlueprint: powerUpBlueprint,
            playerId: userId,
            additionalPlayerIds: nil)
    }

    func hasGameEnd(with gameData: GameMetaData) -> Bool {
        guard let playerLocationId = gameData.locationMapping[gameData.playerId]?.location else {
            return false
        }
        return playerLocationId == gameData.topPlatformId
    }

}
