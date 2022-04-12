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

    private(set) var seed: Int = 161_001 // Int.random(in: (Int.min ... Int.max))

    private var players = [PlayerInfo]()

    func getGameRules() -> GameRules {
        TimeTrialGameRules()
    }

    mutating func setSeed(_ seed: Int) {
        self.seed = seed
    }

    mutating func setPlayers(_ players: [PlayerInfo]) {
        self.players = players

        let shadowPlayer = PlayerInfo(playerId: GameConstants.shadowPlayerID, displayName: "Shadow Rank 1")
        self.players.append(shadowPlayer)
    }

    func getIdOrderedPlayers() -> [PlayerInfo] {
        players
    }

    func createPreGameManager(_ lobbyId: NetworkID) -> PreGameManager {
        let endpoint = generateNonIdentifyingEndpointPath()
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

    private func generateNonIdentifyingEndpointPath() -> String {
        "\(seed)/\(urlSafeName)"
    }

    private func generateEndpointPath(_ lobbyId: NetworkID) -> String {
        "\(seed)/\(urlSafeName)/\(lobbyId)"
    }
}
