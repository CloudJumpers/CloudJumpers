//
//  TimeTrial.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/4/22.
//

import Foundation

struct TimeTrial: GameMode {
    let name = "TimeTrial"

    let minimumPlayers: Int = 1
    let maximumPlayers: Int = 1

    let lobbyPlayedIn: NetworkID
    let seed: Int = 161_001

    private var endpointKey: String {
        "\(seed)/\(urlSafeName)/\(lobbyPlayedIn)"
    }

    init(_ lobbyPlayedIn: NetworkID) {
        self.lobbyPlayedIn = lobbyPlayedIn
    }

    func getGameRules() -> GameRules {
        TimeTrialGameRules()
    }

    func createPreGameManager() -> PreGameManager {
        TimeTrialPreGameManager(endpointKey, lobbyPlayedIn)
    }

    func createPostGameManager(metaData: GameMetaData) -> PostGameManager {
        let completionData = TimeTrialData(
            playerId: metaData.playerId,
            playerName: metaData.playerName,
            completionTime: metaData.time
        )

        return TimeTrialPostGameManager(completionData, endpointKey, lobbyPlayedIn)
    }
}
