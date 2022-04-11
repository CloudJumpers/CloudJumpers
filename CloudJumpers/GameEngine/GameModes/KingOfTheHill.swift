//
//  KingOfTheHill.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 12/4/22.
//

import Foundation

struct KingOfTheHill: GameMode {
    let name = GameModeConstants.kingOfTheHill

    var minimumPlayers = 3
    var maximumPlayers = 4

    let seed: Int = 161_001

    func getGameRules() -> GameRules {
        KingOfTheHillGameRules()
    }

    func createPreGameManager(_ lobbyId: NetworkID) -> PreGameManager {
        KingOfTheHillPreGameManager(lobbyId)
    }

    func createPostGameManager(_ lobbyId: NetworkID, metaData: GameMetaData) -> PostGameManager {
        let completionData = KingOfTheHillData(
            playerId: metaData.playerId,
            playerName: metaData.playerName
        )

        let endpoint = generateEndpoint(lobbyId)
        return KingOfTheHillPostGameManager(completionData, endpoint)
    }

    private func generateEndpoint(_ lobbyId: NetworkID) -> String {
        "\(seed)/\(urlSafeName)/\(lobbyId)"
    }
}
