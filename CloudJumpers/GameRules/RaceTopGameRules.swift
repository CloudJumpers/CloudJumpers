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
            additionalPlayerIds: lobby?.otherUsers.map { $0.id })
    }

    func createGameEvents(with gameData: GameMetaData) -> [Event] {
        var events = [Event]()
        if isPlayerRespawn(with: gameData) {
            events.append(RespawnEvent(onEntityWith: gameData.playerId,
                                       to: gameData.playerStartingPosition))
            gameData.locationMapping.removeValue(forKey: gameData.playerId)
        }
        return events
    }

    private func isPlayerRespawn(with gameData: GameMetaData) -> Bool {

        for character in gameData.locationMapping.keys {
            guard character != gameData.playerId,
                  let characterLocationInfo = gameData.locationMapping[character],
                  let playerLocationInfo = gameData.locationMapping[gameData.playerId]
            else {
                continue
            }

            if characterLocationInfo.location == playerLocationInfo.location &&
                characterLocationInfo.time > playerLocationInfo.time {
                return true
            }
        }
        return false
    }

    func hasGameEnd(with gameData: GameMetaData) -> Bool {
        // Temporary end game condition
        guard let playerLocationId = gameData.locationMapping[gameData.playerId]?.location else {
            return false
        }
        return playerLocationId == gameData.topPlatformId
    }

}
