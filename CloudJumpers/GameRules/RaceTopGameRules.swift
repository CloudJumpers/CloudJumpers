//
//  RaceTopGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/30/22.
//

import Foundation

class RaceTopGameRules: GameRules {

    unowned var lobby: GameLobby?

    init(with lobby: GameLobby?) {
        self.lobby = lobby
    }

    func prepareGameModes(gameEngine: GameEngine, blueprint: Blueprint) {
        guard let userId = AuthService().getUserId() else {
            fatalError("Cannot find user")
        }

        gameEngine.setUpGame(
            with: blueprint,
            playerId: userId,
            additionalPlayerIds: lobby?.otherUsers.map { $0.id })
    }

    func createGameEvents(with gameData: GameMetaData) -> [Event] {
        var events = [Event]()
        for player in gameData.playerLocationMapping.keys where player != gameData.playerId {
            if gameData.playerLocationMapping[player] == gameData.playerLocationMapping[gameData.playerId] {
                events.append(RespawnEvent(onEntityWith: gameData.playerId, at: gameData.time))
            }
        }
        return events
    }

    func hasGameEnd(with gameData: GameMetaData) -> Bool {
        false
    }

}
