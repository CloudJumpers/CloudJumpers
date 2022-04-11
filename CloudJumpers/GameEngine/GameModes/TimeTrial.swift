//
//  TimeTrial.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/4/22.
//

import Foundation

struct TimeTrial: GameMode {
    let name = GameModeConstants.timeTrials

    let minimumPlayers: Int = 1
    let maximumPlayers: Int = 1

    let seed: Int = 161_001

    func getGameRules() -> GameRules {
        TimeTrialGameRules()
    }

    func createPreGameManager(_ lobbyId: NetworkID) -> PreGameManager {
        let endpoint = generateEndpointPath(lobbyId)
        return TimeTrialPreGameManager(endpoint, lobbyId)
    }

    func createPostGameManager(_ lobbyId: NetworkID, metaData: GameMetaData) -> PostGameManager {
        let completionData = TimeTrialData(
            playerId: metaData.playerId,
            playerName: metaData.playerName,
            completionTime: metaData.time
        )

        let endpoint = generateEndpointPath(lobbyId)
        return TimeTrialPostGameManager(completionData, endpoint, lobbyId)
    }

    private func generateEndpointPath(_ lobbyId: NetworkID) -> String {
        "\(seed)/\(urlSafeName)/\(lobbyId)"
    }
}
