//
//  RaceToTop.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/4/22.
//

import Foundation

struct RaceToTop: GameMode {
    let name = GameModeConstants.raceToTop

    var minimumPlayers: Int = 2
    var maximumPlayers: Int = 4

    private(set) var seed: Int = 161_001

    func getGameRules() -> GameRules {
        RaceTopGameRules()
    }

    mutating func setSeed(_ seed: Int) {
        self.seed = seed
    }

    func createPreGameManager(_ lobbyId: NetworkID) -> PreGameManager {
        RaceToTopPreGameManager(lobbyId)
    }

    func createPostGameManager(_ lobbyId: NetworkID, metaData: GameMetaData) -> PostGameManager {
        let completionData = RaceToTopData(
            playerId: metaData.playerId,
            playerName: metaData.playerName,
            completionTime: metaData.time
        )

        let endpoint = generateEndpoint(lobbyId)
        return RaceToTopPostGameManager(completionData, endpoint)
    }

    private func generateEndpoint(_ lobbyId: NetworkID) -> String {
        "\(seed)/\(urlSafeName)/\(lobbyId)"
    }
}
