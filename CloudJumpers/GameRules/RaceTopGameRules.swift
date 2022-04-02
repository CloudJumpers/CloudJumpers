//
//  RaceTopGameRules.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/30/22.
//

import Foundation

class RaceTopGameRules: GameRules {
    func createGameEvents(with gameData: GameMetaData) -> (localEvents: [Event], remoteEvents: [RemoteEvent]) {
        var localEvents = [Event]()
        var remoteEvents = [RemoteEvent]()

        if isPlayerRespawn(with: gameData) {
            localEvents.append(RespawnEvent(
                onEntityWith: gameData.playerId,
                to: gameData.playerStartingPosition)
            )

            remoteEvents.append(ExternalRespawnEvent(
                positionX: gameData.playerStartingPosition.x,
                positionY: gameData.playerStartingPosition.y
            ))

            gameData.locationMapping.removeValue(forKey: gameData.playerId)
        }
        return (localEvents, remoteEvents)
    }

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
