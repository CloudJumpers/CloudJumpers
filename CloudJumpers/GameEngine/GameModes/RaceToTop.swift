//
//  RaceToTop.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/4/22.
//

import Foundation

struct RaceToTop: GameMode {
    let name = "RaceToTop"

    var minimumPlayers: Int = 2
    var maximumPlayers: Int = 4

    let lobbyPlayedIn: NetworkID
    let seed: Int = 161_001

    init(_ lobbyPlayedIn: NetworkID) {
        self.lobbyPlayedIn = lobbyPlayedIn
    }

    func getGameRules() -> GameRules {
        RaceTopGameRules()
    }

    func createPreGameManager() -> PreGameManager {
        RaceToTopPreGameManager(lobbyPlayedIn)
    }

    func createPostGameManager(metaData: GameMetaData) -> PostGameManager {
        let completionData = RaceToTopData(
            playerId: metaData.playerId,
            playerName: metaData.playerName,
            completionTime: metaData.time
        )

        return RaceToTopPostGameManager(completionData, seed, lobbyPlayedIn)
    }
}
